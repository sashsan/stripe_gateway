# frozen_string_literal: true

module StripeGateway
  # ApiResponse for Stripe
  class ApiResponse
    include ApplicationHelper

    attr_accessor :response

    def initialize(response)
      @response = response
    end

    def url
      @url ||= get_nested_value(response, 'url')
    end

    def id
      @id ||= get_nested_value(response, 'id')
    end
  end
end
