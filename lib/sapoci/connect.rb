require 'faraday'
require 'sapoci'
require 'sapoci/connect/middleware/follow_redirects'
require 'sapoci/connect/middleware/pass_cookies'
require 'sapoci/connect/middleware/background_search'

module SAPOCI
  module Connect

    # Perform an OCI background search.
    # 
    # If you need to follow redirects and pass cookies along, you should
    # initialize and use Faraday with this pattern:
    #
    #   conn = Faraday.new("http://shop.com/path", :params => {"optional" => "value"}) do |builder| 
    #     builder.use SAPOCI::Connect::Middleware::FollowRedirects
    #     builder.use SAPOCI::Connect::Middleware::PassCookies
    #     builder.use SAPOCI::Connect::Middleware::BackgroundSearch
    #     builder.adapter :net_http
    #   end
    #   conn.options[:timeout] = 3
    #   conn.options[:open_timeout] = 5
    #   resp = SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me")
    #   puts resp.status # => 200
    #   puts resp.body   # => <SAPOCI::Document>
    #
    def self.search(method, connection, keywords, hook_url, extra_params = nil)
      params = {
        "FUNCTION" => "BACKGROUND_SEARCH",
        "SEARCHSTRING" => keywords,
        "HOOK_URL" => hook_url
      }
      params.update(extra_params) if extra_params

      unless connection.builder.handlers.include?(SAPOCI::Connect::Middleware::BackgroundSearch)
        connection.use SAPOCI::Connect::Middleware::BackgroundSearch
      end

      case method.to_sym
      when :get
        connection.get do |req|
          req.params = params
        end
      when :post
        connection.post do |req|
          req.body = Faraday::Utils.build_nested_query params
        end
      else
        raise "SAPOCI::Connect.search only allows :get or :post requests"
      end
    end

  end
end
