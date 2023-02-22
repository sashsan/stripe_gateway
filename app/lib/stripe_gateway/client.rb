# frozen_string_literal: true

module StripeGateway
  # Base class for Stripe
  class Client
    Error = Class.new(StandardError)

    STRIPE_URI = 'api.stripe.com/v1/checkout'
    PROJECT_URL = 'http://localhost:3000/'

    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def create_session(product:, quantity:, currency:)
      api_request(
        url_with_path('/sessions'),
        ::StripeGateway::ApiRequestFactory
          .new(product: product, quantity: quantity, currency: currency)
          .create_session
          .as_json
      )
    end

    private

    def api_request(url, params = {})
      response = http_post(url, params)

      ::StripeGateway::ApiResponse.new(response)
    end

    def http_post(url, params)
      http_request do
        HTTParty.post(url, request_params.tap do |o|
          o[:body] = o[:body].merge(params)
        end)
      end
    end

    def http_request(&block)
      response = handle_request_exception(&block)

      handle_response(response)
    end

    def request_params
      {
        headers: {
          'Authorization': "Bearer #{Rails.application.credentials.stripe[:api_secret]}"
        },
        body: {
          success_url: PROJECT_URL,
          cancel_url: PROJECT_URL
        }
      }
    end

    # rubocop:disable Metrics/MethodLength
    def handle_request_exception
      yield
    rescue ::OpenSSL::SSL::SSLError
      raise_error 'Stripe returned invalid SSL data'
    rescue ::Net::OpenTimeout
      raise_error 'Stripe connection timed out'
    rescue ::SocketError
      raise_error 'Received a SocketError while trying to connect to Stripe'
    rescue ::Errno::ECONNREFUSED
      raise_error 'Connection refused'
    rescue StandardError => e
      raise_error "Stripe request failed due to #{e.class}"
    end

    # rubocop:enable Metrics/MethodLength

    def handle_response(response)
      return { body: response.parsed_response, headers: response.headers } if response.code < 400

      raise_error "Stripe response status code: #{response.code}, Message: #{response.body}"
    end

    def raise_error(message)
      raise Client::Error, message
    end

    def url_with_path(new_path)
      new_uri = stripe_uri.dup
      new_uri.path += [new_path].join('/').squeeze('/')
      new_uri.to_s
    end

    def stripe_uri
      @stripe_uri ||= URI("https://#{STRIPE_URI}").freeze
    end
  end
end
