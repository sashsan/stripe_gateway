# frozen_string_literal: true

# CheckoutsController for making payment
class CheckoutsController < ApplicationController
  def create
    product = Product.find(params[:product_id])

    result = stripe.create_session(product: product, quantity: 1, currency: 'usd')

    Product.transaction do
      product.with_lock do
        product.stripe_id = result.id
        product.save!
      end
    end

    redirect_to(result.url, allow_other_host: true)
  end

  private

  def stripe
    @stripe ||= ::StripeGateway::Client.new('Stripe')
  end
end
