;; Demand Forecasting Contract
;; Forecasts travel demand based on historical data and market conditions

(define-data-var admin principal tx-sender)

;; Map of demand forecasts by location and date
(define-map demand-forecasts
  {
    location: (string-utf8 100),
    date: uint
  }
  {
    expected-demand: uint,
    confidence-level: uint,
    last-updated: uint,
    factors: (list 5 (string-utf8 50))
  }
)

;; Map of historical demand data
(define-map historical-demand
  {
    location: (string-utf8 100),
    date: uint
  }
  {
    actual-demand: uint,
    factors: (list 5 (string-utf8 50))
  }
)

;; Public function to add a demand forecast
(define-public (add-forecast
                (location (string-utf8 100))
                (date uint)
                (expected-demand uint)
                (confidence-level uint)
                (factors (list 5 (string-utf8 50))))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (asserts! (<= confidence-level u100) (err u400))
    (ok (map-set demand-forecasts
      { location: location, date: date }
      {
        expected-demand: expected-demand,
        confidence-level: confidence-level,
        last-updated: block-height,
        factors: factors
      }
    ))
  )
)

;; Public function to record historical demand
(define-public (record-historical-demand
                (location (string-utf8 100))
                (date uint)
                (actual-demand uint)
                (factors (list 5 (string-utf8 50))))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (map-set historical-demand
      { location: location, date: date }
      {
        actual-demand: actual-demand,
        factors: factors
      }
    ))
  )
)

;; Read-only function to get demand forecast
(define-read-only (get-demand-forecast (location (string-utf8 100)) (date uint))
  (map-get? demand-forecasts { location: location, date: date })
)

;; Read-only function to get historical demand
(define-read-only (get-historical-demand (location (string-utf8 100)) (date uint))
  (map-get? historical-demand { location: location, date: date })
)

;; Read-only function to calculate forecast accuracy
(define-read-only (calculate-forecast-accuracy (location (string-utf8 100)) (date uint))
  (let (
    (forecast (map-get? demand-forecasts { location: location, date: date }))
    (actual (map-get? historical-demand { location: location, date: date }))
  )
    (if (and (is-some forecast) (is-some actual))
      (let (
        (expected (get expected-demand (unwrap-panic forecast)))
        (actual-value (get actual-demand (unwrap-panic actual)))
      )
        (some (if (> expected actual-value)
          (- u100 (/ (* (- expected actual-value) u100) expected))
          (- u100 (/ (* (- actual-value expected) u100) actual-value))
        ))
      )
      none
    )
  )
)

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (var-set admin new-admin)
    (ok true)
  )
)
