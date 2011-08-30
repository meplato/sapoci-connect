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
    #   conn = Faraday.new(uri.to_s, :params => params) do |builder| 
    #     builder.use SAPOCI::Connect::Middleware::FollowRedirects
    #     builder.use SAPOCI::Connect::Middleware::PassCookies
    #     builder.use SAPOCI::Connect::Middleware::BackgroundSearch
    #     builder.adapter adapter
    #   end
    #   resp = SAPOCI::Connect.search(conn, "toner", "http://return.to/me")
    #   puts resp.status # => 200
    #   puts resp.body   # => <SAPOCI::Document>
    #
    def self.search(connection, keywords, hook_url, extra_params = nil)
      connection.params["FUNCTION"]     = "BACKGROUND_SEARCH"
      connection.params["SEARCHSTRING"] = keywords
      connection.params["HOOK_URL"]     = hook_url
      connection.params.update(extra_params) if extra_params
      # TODO inject standard middleware
      unless connection.builder.handlers.include?(SAPOCI::Connect::Middleware::BackgroundSearch)
        connection.use SAPOCI::Connect::Middleware::BackgroundSearch
      end
      connection.get
    end

  end
end
