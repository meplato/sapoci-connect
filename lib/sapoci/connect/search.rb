module SAPOCI
  module Connect
    class Search
      attr_reader :url, :hook_url, :params, :last_response

      def initialize(url, hook_url, options = {})
        @host_and_path, @params = SAPOCI::Connect.parse_url(url)
        @params ||= {}
        @params.update(options[:params]) if options[:params]
        @hook_url = hook_url
      end

      def search(keywords, extra_params = nil)
        params = build_params(keywords, extra_params)
        conn = SAPOCI::Connect.build_connection(@host_and_path, :params => params)
        resp = conn.get
        @last_response = resp
        SAPOCI::Document.from_html(resp.body)
      end

      def build_params(keywords, extra_params = nil)
        params = @params.dup
        params["SEARCHSTRING"] = keywords
        params["FUNCTION"]     = "BACKGROUND_SEARCH"
        params["HOOK_URL"]     = @hook_url
        params.update extra_params if extra_params
        params
      end

      def build_url(keywords, extra_params = nil)
        uri = URI.parse(@host_and_path)
        params = build_params(keywords, extra_params)
        uri.query = params.empty? ? nil : Rack::Utils.build_query(params)
        uri.to_s
      end
    end
  end
end
