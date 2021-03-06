# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

class SearchRemoteTest < SAPOCI::Connect::TestCase

  if ENV['REMOTE']

    def setup
      @url = ENV['REMOTE']
      WebMock.disable_net_connect!(allow_localhost: true, allow: @url)
    end

    def test_should_return_search_results_from_remote_server
      SAPOCI::Connect::TestCase::ADAPTERS.each do |adapter|
        # Parse URL and query parameters
        uri = URI.parse(@url)
        params = Rack::Utils.parse_query(uri.query) if uri.query
        uri.query = nil
        # Setup
        conn = Faraday.new(uri.to_s, params: params)
        # Execute
        assert resp = SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me")
        assert_equal 200, resp.status
        assert resp.env[:raw_body].is_a?(String)
        assert doc = resp.body
        assert doc.is_a?(SAPOCI::Document)
        assert doc.items.size > 0
      end
    end
    
  end

end

