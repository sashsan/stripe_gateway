# frozen_string_literal: true

module StripeGateway
  # ApiRequestFactory for Stripe
  class ApiRequestFactory
    attr_accessor :product,
                  :quantity,
                  :currency

    def initialize(
      product:,
      quantity:,
      currency:
    )

      @product = product
      @quantity = quantity
      @currency = currency
    end

    # rubocop:disable Metrics/MethodLength
    def create_session
      {
        mode: 'payment',
        line_items: [
          {
            price_data: {
              currency: currency,
              unit_amount: product.price,
              product_data: {
                name: product.name
              }
            },
            quantity: quantity
          }
        ]
      }
    end
    # rubocop:enable Metrics/MethodLength
  end
end
