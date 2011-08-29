require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

class SearchTest < SAPOCI::Connect::TestCase

  def setup
    WebMock.disable_net_connect!(:allow_localhost => true)
  end

  def test_build_url_generates_correct_urls
    assert_equal "http://ocisite.com/?SEARCHSTRING=keyword&FUNCTION=BACKGROUND_SEARCH&HOOK_URL=http%3A%2F%2Freturn.to%2Fme",
                 SAPOCI::Connect::Search.new("http://ocisite.com/", "http://return.to/me").build_url("keyword")
  end

  def test_build_url_overrides_with_extra_params
    assert_equal "http://ocisite.com/?SEARCHSTRING=OVERRIDE-ME&FUNCTION=BACKGROUND_SEARCH&HOOK_URL=http%3A%2F%2Freturn.to%2Fme",
                 SAPOCI::Connect::Search.new("http://ocisite.com/", "http://return.to/me").build_url("keyword", "SEARCHSTRING" => "OVERRIDE-ME")
  end

  def test_build_url_accepts_params_in_url
    assert_equal "http://ocisite.com/path?token=123&SEARCHSTRING=keyword&FUNCTION=BACKGROUND_SEARCH&HOOK_URL=http%3A%2F%2Freturn.to%2Fme",
                 SAPOCI::Connect::Search.new("http://ocisite.com/path", "http://return.to/me", :params => {"token" => "123"}).build_url("keyword")
  end

    
  def test_should_return_hello_world
    conn = Faraday::Connection.new(:url => "http://localhost:4567")
    assert_equal 200, conn.get("/").status
  end

  def test_should_return_search_results
    SAPOCI::Connect::TestCase::ADAPTERS.each do |adapter|
      SAPOCI::Connect.default_adapter = adapter
      hook_url = "http://return.to/me"
      command = SAPOCI::Connect::Search.new("http://localhost:4567/search", hook_url)
      assert data = command.search("toner")
      assert_equal 200, command.last_response.status
      assert_equal 2, data.items.size
      assert_equal "MBA11", data.items[0].vendormat
      assert_equal "IMAC27", data.items[1].vendormat
    end
  end

  def test_should_follow_redirects_and_return_search_results
    SAPOCI::Connect::TestCase::ADAPTERS.each do |adapter|
      SAPOCI::Connect.default_adapter = adapter
      hook_url = "http://return.to/me"
      command = SAPOCI::Connect::Search.new("http://localhost:4567/search/redirect", hook_url, :params => {"adapter" => adapter})
      assert data = command.search("toner")
      assert_equal 200, command.last_response.status
      assert_equal 2, data.items.size
      assert_equal "MBA11", data.items[0].vendormat
      assert_equal "IMAC27", data.items[1].vendormat
    end
  end

  def test_should_follow_redirects_and_pass_cookies_and_return_search_results
    SAPOCI::Connect::TestCase::ADAPTERS.each do |adapter|
      SAPOCI::Connect.default_adapter = adapter
      hook_url = "http://return.to/me"
      command = SAPOCI::Connect::Search.new("http://localhost:4567/search/redirect-and-cookies", hook_url, :params => {"adapter" => adapter})
      assert data = command.search("toner")
      assert_equal 200, command.last_response.status
      assert_equal 2, data.items.size
      assert_equal "MBA11", data.items[0].vendormat
      assert_equal "IMAC27", data.items[1].vendormat
    end
  end

end

