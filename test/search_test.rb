require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

class SearchTest < SAPOCI::Connect::TestCase

  def setup
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  def test_build_url_generates_correct_urls
    stub_request(:get, "http://ocisite.com/path?FUNCTION=BACKGROUND_SEARCH&HOOK_URL=http://return.to/me&SEARCHSTRING=toner&extra-token=123").to_return(body: "success")
    conn = build_connection("http://ocisite.com/path")
    assert resp = SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me", {"extra-token" => "123"})
    assert_equal                "http", resp.env[:url].scheme
    assert_equal         "ocisite.com", resp.env[:url].host
    assert_equal               "/path", resp.env[:url].path
    # Ruby 1.9 uses URI::HTTP, earlier versions used Adressable::URI
    qsh = Rack::Utils.parse_query(resp.env[:url].query)
    assert_equal               "toner", qsh["SEARCHSTRING"]
    assert_equal   "BACKGROUND_SEARCH", qsh["FUNCTION"]
    assert_equal "http://return.to/me", qsh["HOOK_URL"]
    assert_equal                 "123", qsh["extra-token"]
  end
  
  def test_background_search_middleware
    params = {'FUNCTION' => 'BACKGROUND_SEARCH', 'SEARCHSTRING' => '*', 'HOOK_URL' => 'http://test.local'}
    conn = Faraday.new("http://localhost:4567/search", params: params) do |connection|
      connection.use SAPOCI::Connect::Middleware::FollowRedirects
      connection.use SAPOCI::Connect::Middleware::BackgroundSearch, {preserve_raw: true}
    end
    assert resp = conn.get
    assert resp.env[:raw_body].is_a?(String)
    assert doc = resp.body
    assert doc.is_a?(SAPOCI::Document)
    assert_equal 2, doc.items.size
  end
  
  def test_background_search_middleware_with_symbols
    params = {'FUNCTION' => 'BACKGROUND_SEARCH', 'SEARCHSTRING' => '*', 'HOOK_URL' => 'http://test.local'}
    conn = Faraday.new("http://localhost:4567/search", params: params) do |connection|
      connection.use :oci_follow_redirects
      connection.use :oci_background_search, {preserve_raw: true}
    end
    assert resp = conn.get
    assert resp.env[:raw_body].is_a?(String)
    assert doc = resp.body
    assert doc.is_a?(SAPOCI::Document)
    assert_equal 2, doc.items.size
  end
  
  def test_background_search_middleware_with_post
    body = {'FUNCTION' => 'BACKGROUND_SEARCH', 'SEARCHSTRING' => '*', 'HOOK_URL' => 'http://test.local'}
    conn = Faraday.new(
      url: "http://localhost:4567/search-with-post",
      headers: {"Content-Type" => "application/x-www-form-urlencoded"}) do |connection|
      connection.use :oci_follow_redirects
      connection.use :oci_background_search, {preserve_raw: true}
    end
    resp = conn.post do |req|
      req.body = Faraday::Utils.build_nested_query(body)
    end
    assert resp
    assert resp.env[:raw_body].is_a?(String)
    assert doc = resp.body
    assert doc.is_a?(SAPOCI::Document)
    assert_equal 2, doc.items.size
  end

  def test_search_api_injects_follow_redirects_middleware
    conn = Faraday.new("http://localhost:4567/search")
    SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me", extra_token: "123")
    assert conn.builder.handlers.include?(SAPOCI::Connect::Middleware::FollowRedirects)
  end

  def test_search_api_injects_bgs_middleware
    conn = Faraday.new("http://localhost:4567/search")
    SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me", extra_token: "123")
    assert conn.builder.handlers.include?(SAPOCI::Connect::Middleware::BackgroundSearch)
  end

  def test_should_return_hello_world
    conn = Faraday::Connection.new(url: "http://localhost:4567")
    assert_equal 200, conn.get("/").status
  end

  def test_should_return_search_results
    SAPOCI::Connect::TestCase::ADAPTERS.each do |adapter|
      url = "http://localhost:4567/search"
      conn = build_connection(url)
      assert resp = SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me")
      assert_equal 200, resp.status
      assert resp.env[:raw_body].is_a?(String)
      assert doc = resp.body
      assert doc.is_a?(SAPOCI::Document)
      assert_equal 2, doc.items.size
      assert_equal "MBA11", doc.items[0].vendormat
      assert_equal "Ein tolles Notebook von Apple.", doc.items[0].longtext
      assert_equal "IMAC27", doc.items[1].vendormat
      assert_equal "Der elegante Desktop-Rechner von Apple.", doc.items[1].longtext
    end
  end

  def test_should_return_search_results_with_post
    SAPOCI::Connect::TestCase::ADAPTERS.each do |adapter|
      url = "http://localhost:4567/search-with-post"
      conn = build_connection(url)
      assert resp = SAPOCI::Connect.search(:post, conn, "toner", "http://return.to/me")
      assert_equal 200, resp.status
      assert resp.env[:raw_body].is_a?(String)
      assert doc = resp.body
      assert doc.is_a?(SAPOCI::Document)
      assert_equal 2, doc.items.size
      assert_equal "MBA11", doc.items[0].vendormat
      assert_equal "IMAC27", doc.items[1].vendormat
    end
  end

  def test_should_follow_redirects_and_return_search_results
    SAPOCI::Connect::TestCase::ADAPTERS.each do |adapter|
      url = "http://localhost:4567/search/redirect"
      conn = Faraday.new(url) do |builder| 
        builder.adapter adapter
      end
      assert resp = SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me")
      assert_equal 200, resp.status
      assert resp.env[:raw_body].is_a?(String)
      assert doc = resp.body
      assert doc.is_a?(SAPOCI::Document)
      assert_equal 2, doc.items.size
      assert_equal "MBA11", doc.items[0].vendormat
      assert_equal "IMAC27", doc.items[1].vendormat
    end
  end

  def test_should_follow_redirects_with_relative_location_and_return_search_results
    SAPOCI::Connect::TestCase::ADAPTERS.each do |adapter|
      url = "http://localhost:4567/search/redirect-with-relative-location"
      conn = Faraday.new(url) do |builder| 
        builder.adapter adapter
      end
      assert resp = SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me")
      assert_equal 200, resp.status
      assert resp.env[:raw_body].is_a?(String)
      assert doc = resp.body
      assert doc.is_a?(SAPOCI::Document)
      assert_equal 2, doc.items.size
      assert_equal "MBA11", doc.items[0].vendormat
      assert_equal "IMAC27", doc.items[1].vendormat
    end
  end

  def test_should_follow_redirects_and_pass_cookies_and_return_search_results
    SAPOCI::Connect::TestCase::ADAPTERS.each do |adapter|
      url = "http://localhost:4567/search/redirect-and-cookies"
      conn = Faraday.new(url) do |builder|
        builder.adapter adapter
      end
      assert resp = SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me")
      assert_equal 200, resp.status
      assert resp.env[:raw_body].is_a?(String)
      assert doc = resp.body
      assert doc.is_a?(SAPOCI::Document)
      assert_equal 2, doc.items.size
      assert_equal "MBA11", doc.items[0].vendormat
      assert_equal "IMAC27", doc.items[1].vendormat
    end
  end

  def test_should_follow_redirects_and_pass_cookies_without_domain_and_path_and_return_search_results
    SAPOCI::Connect::TestCase::ADAPTERS.each do |adapter|
      url = "http://localhost:4567/search/redirect-and-cookies-and-domain-and-path"
      conn = Faraday.new(url) do |builder| 
        builder.adapter adapter
      end
      assert resp = SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me")
      assert_equal 200, resp.status
      assert resp.env[:raw_body].is_a?(String)
      assert doc = resp.body
      assert doc.is_a?(SAPOCI::Document)
      assert_equal 2, doc.items.size
      assert_equal "MBA11", doc.items[0].vendormat
      assert_equal "IMAC27", doc.items[1].vendormat
    end
  end

  def test_should_pass_allowed_cookies
    SAPOCI::Connect::TestCase::ADAPTERS.each do |adapter|
      ['session_id', :session_id].each do |cookie_name|
        url = "http://localhost:4567/search/redirect-and-cookies"
        conn = Faraday.new(url) do |builder|
          builder.use :oci_follow_redirects, {cookies: [cookie_name]}
          builder.adapter adapter
        end
        assert resp = SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me")
        assert_equal 200, resp.status
        assert resp.env[:raw_body].is_a?(String)
        assert doc = resp.body
        assert doc.is_a?(SAPOCI::Document)
        assert_equal 2, doc.items.size
        assert_equal "MBA11", doc.items[0].vendormat
        assert_equal "IMAC27", doc.items[1].vendormat
      end
    end
  end

  def test_should_not_pass_denied_cookies
    SAPOCI::Connect::TestCase::ADAPTERS.each do |adapter|
      url = "http://localhost:4567/search/redirect-and-cookies"
      conn = Faraday.new(url) do |builder|
        builder.use :oci_follow_redirects, {cookies: ['no_such_cookie']} # session_id is not allowed
        builder.adapter adapter
      end
      assert resp = SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me")
      # The test server will respond with 404 if there is no cookie namend 'session_id'
      assert_equal 404, resp.status
    end
  end

  def test_should_timeout
    SAPOCI::Connect::TestCase::ADAPTERS.each do |adapter|
      begin
        url = "http://localhost:4567/search-timeout"
        conn = build_connection(url)
        conn.options[:timeout] = 2
        conn.options[:open_timeout] = 3
        SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me")
        assert false, "Should receive timeout"
      rescue Faraday::TimeoutError
      rescue Timeout::Error
      end
    end
  end

  def test_should_handle_redirects_without_location_gracefully
    SAPOCI::Connect::TestCase::ADAPTERS.each do |adapter|
      url = "http://localhost:4567/search/redirect-without-location"
      conn = Faraday.new(url) do |builder| 
        builder.adapter adapter
      end
      assert_raise(SAPOCI::Connect::Middleware::RedirectWithoutLocation) do
        SAPOCI::Connect.search(:get, conn, "toner", "http://return.to/me")
      end
    end
  end

end

