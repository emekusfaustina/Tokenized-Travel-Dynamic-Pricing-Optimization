;; Customer Segmentation Contract
;; Segments travel customers based on behavior and preferences

(define-data-var admin principal tx-sender)

;; Map of customer profiles
(define-map customer-profiles
  {
    customer: principal
  }
  {
    segment: (string-utf8 50),
    loyalty-tier: (string-utf8 20),
    lifetime-value: uint,
    travel-frequency: uint,
    preferences: (list 5 (string-utf8 50)),
    last-updated: uint
  }
)

;; Map of segment definitions
(define-map segment-definitions
  {
    segment-id: (string-utf8 50)
  }
  {
    description: (string-utf8 100),
    min-loyalty-score: uint,
    min-travel-frequency: uint,
    price-sensitivity: uint,
    created-by: principal
  }
)

;; Public function to create or update a customer profile
(define-public (update-customer-profile
                (segment (string-utf8 50))
                (loyalty-tier (string-utf8 20))
                (lifetime-value uint)
                (travel-frequency uint)
                (preferences (list 5 (string-utf8 50))))
  (let (
    (customer tx-sender)
  )
    (asserts! (is-some (map-get? segment-definitions { segment-id: segment })) (err u404))
    (ok (map-set customer-profiles
      { customer: customer }
      {
        segment: segment,
        loyalty-tier: loyalty-tier,
        lifetime-value: lifetime-value,
        travel-frequency: travel-frequency,
        preferences: preferences,
        last-updated: block-height
      }
    ))
  )
)

;; Admin function to create a segment definition
(define-public (create-segment
                (segment-id (string-utf8 50))
                (description (string-utf8 100))
                (min-loyalty-score uint)
                (min-travel-frequency uint)
                (price-sensitivity uint))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (map-set segment-definitions
      { segment-id: segment-id }
      {
        description: description,
        min-loyalty-score: min-loyalty-score,
        min-travel-frequency: min-travel-frequency,
        price-sensitivity: price-sensitivity,
        created-by: tx-sender
      }
    ))
  )
)

;; Read-only function to get customer profile
(define-read-only (get-customer-profile (customer principal))
  (map-get? customer-profiles { customer: customer })
)

;; Read-only function to get segment definition
(define-read-only (get-segment-definition (segment-id (string-utf8 50)))
  (map-get? segment-definitions { segment-id: segment-id })
)

;; Read-only function to check if customer is in segment
(define-read-only (is-customer-in-segment (customer principal) (segment-id (string-utf8 50)))
  (let (
    (profile (map-get? customer-profiles { customer: customer }))
  )
    (and (is-some profile) (is-eq (get segment (unwrap-panic profile)) segment-id))
  )
)

;; Read-only function to get price adjustment for customer
(define-read-only (get-customer-price-adjustment (customer principal))
  (let (
    (profile (map-get? customer-profiles { customer: customer }))
  )
    (if (is-some profile)
      (let (
        (unwrapped-profile (unwrap-panic profile))
        (segment-id (get segment unwrapped-profile))
        (segment-def (map-get? segment-definitions { segment-id: segment-id }))
      )
        (if (is-some segment-def)
          (some (get price-sensitivity (unwrap-panic segment-def)))
          (some u100) ;; Default to no adjustment (100%)
        )
      )
      (some u100) ;; Default to no adjustment (100%)
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
