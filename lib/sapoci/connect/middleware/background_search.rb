# frozen_string_literal: true

require 'faraday_middleware/response_middleware'

module SAPOCI
  module Connect
    module Middleware
      # BackgroundSearch is a Faraday response middleware that parses
      # the response body into a SAPOCI::Document.
      #
      # If you want Faraday to preserve the original HTTP response body,
      # pass `preserve_raw: true` to the parser.
      #
      # Example:
      # 
      #   conn = Faraday.new("http://onlineshop.com/path", params: {"token" => "123"}) do |builder|
      #     builder.use SAPOCI::Connect::Middleware::FollowRedirects, {cookies: :all, limit: 5}
      #     builder.use SAPOCI::Connect::Middleware::BackgroundSearch, {preserve_raw: true}
      #     builder.adapter :net_http
      #   end
      class BackgroundSearch < FaradayMiddleware::ResponseMiddleware
        dependency 'sapoci'

        define_parser do |body, parser_options|
          ::SAPOCI::Document.from_html(body) unless body.empty?
        end
      end

      # Register known middlewares under symbol
      if Faraday::Middleware.respond_to?(:register_middleware)
        Faraday::Middleware.register_middleware oci_background_search: -> { SAPOCI::Connect::Middleware::BackgroundSearch }
      end
    end
  end
end
