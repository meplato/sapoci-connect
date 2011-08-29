require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

class SearchRemoteTest < SAPOCI::Connect::TestCase

  if ENV['REMOTE']

    def setup
      @url = ENV['REMOTE']
      WebMock.disable_net_connect!(:allow_localhost => true, :allow => @url)
    end

    def test_should_return_search_results_from_remote_server
      SAPOCI::Connect::TestCase::ADAPTERS.each do |adapter|
        SAPOCI::Connect.default_adapter = adapter
        hook_url = "http://return.to/me"
        command = SAPOCI::Connect::Search.new(@url, hook_url)
        assert data = command.search("toner")
        #puts command.last_response.body
        assert_equal 200, command.last_response.status
        assert data.items.size > 0
      end
    end
    
  end

end

