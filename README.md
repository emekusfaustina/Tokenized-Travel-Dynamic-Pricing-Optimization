# Tokenized Travel Dynamic Pricing Optimization

A blockchain-based system for optimizing travel pricing using smart contracts. This project implements a set of Clarity smart contracts that work together to provide dynamic pricing for travel services based on demand forecasting, inventory management, and customer segmentation.

## Overview

The system consists of five main components:

1. **Travel Provider Verification**: Validates and manages travel service providers
2. **Demand Forecasting**: Forecasts travel demand based on historical data and market conditions
3. **Price Optimization**: Optimizes travel pricing based on demand forecasts and market conditions
4. **Inventory Management**: Manages travel inventory and availability
5. **Customer Segmentation**: Segments travel customers based on behavior and preferences

## Smart Contracts

### Travel Provider Verification

This contract handles the verification of travel service providers, ensuring that only legitimate businesses can participate in the system.

Key functions:
- `register-provider`: Register a new travel provider
- `verify-provider`: Admin function to verify a provider
- `update-reputation`: Update provider reputation score
- `is-verified-provider`: Check if a provider is verified
- `get-provider-details`: Get provider details

### Demand Forecasting

This contract forecasts travel demand based on historical data and market conditions.

Key functions:
- `add-forecast`: Add a demand forecast for a location and date
- `record-historical-demand`: Record actual historical demand
- `get-demand-forecast`: Get demand forecast for a location and date
- `get-historical-demand`: Get historical demand for a location and date
- `calculate-forecast-accuracy`: Calculate forecast accuracy

### Price Optimization

This contract optimizes travel pricing based on demand forecasts and market conditions.

Key functions:
- `set-price-constraints`: Set price constraints for a service
- `optimize-price`: Calculate and set optimized price
- `calculate-dynamic-price`: Calculate dynamic price based on factors
- `get-optimized-price`: Get optimized price for a service
- `get-price-constraints`: Get price constraints for a service

### Inventory Management

This contract manages travel inventory and availability.

Key functions:
- `update-inventory`: Add or update inventory
- `create-reservation`: Create a reservation
- `cancel-reservation`: Cancel a reservation
- `get-inventory`: Get inventory for an item
- `get-reservation`: Get reservation details

### Customer Segmentation

This contract segments travel customers based on behavior and preferences.

Key functions:
- `update-customer-profile`: Create or update a customer profile
- `create-segment`: Create a segment definition
- `get-customer-profile`: Get customer profile
- `get-segment-definition`: Get segment definition
- `is-customer-in-segment`: Check if customer is in segment
- `get-customer-price-adjustment`: Get price adjustment for customer

## Testing

Tests are written using Vitest. To run the tests:

```bash
npm test
