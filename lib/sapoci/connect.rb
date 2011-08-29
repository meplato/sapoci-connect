require 'faraday'
require 'sapoci'

module SAPOCI
  module Connect
    class << self
      attr_accessor :default_adapter

      # Create and setups a Faraday connection.
      def build_connection(url, options = {})
        Faraday.new(url, options || {}) do |builder|
          builder.use SAPOCI::Connect::Middleware::FollowRedirects
          builder.use SAPOCI::Connect::Middleware::PassCookies
          builder.adapter self.default_adapter
        end
      end

      # Gets a full-fledged URL and returns scheme+host+path
      # as first parameter and the parsed query parameters 
      # as second.
      def parse_url(url)
        uri = URI.parse(url)
        params = Rack::Utils.parse_query(uri.query) if uri.query
        uri.query = nil
        return uri.to_s, params || {}
      end
    end

    self.default_adapter = :net_http

    autoload :Api,       'sapoci/connect/api'
    autoload :Search,    'sapoci/connect/search'
    module Middleware
      autoload :FollowRedirects, 'sapoci/connect/middleware/follow_redirects'
      autoload :PassCookies,     'sapoci/connect/middleware/pass_cookies'
    end
  end
end
