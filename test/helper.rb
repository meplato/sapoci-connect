require 'rubygems'
require 'test/unit'
require 'rack/utils'

unless $LOAD_PATH.include? 'lib'
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  $LOAD_PATH.unshift(File.join($LOAD_PATH.first, '..', 'lib'))
end
require 'sapoci/connect'

begin
  require 'ruby-debug'
rescue LoadError
  # ignore
else
  Debugger.start
end

module SAPOCI::Connect
  class TestCase < Test::Unit::TestCase
    #ADAPTERS = [:typhoeus] #[:net_http, :em_synchrony, :typhoeus]
    ADAPTERS = [:net_http, :em_synchrony]
    #ADAPTERS = [:net_http]

    def test_default
      assert true
    end unless defined? ::MiniTest

    def build_connection(url, options = {})
      Faraday.new(url, options) do |builder|
        builder.adapter :net_http
      end
    end
  end
end

require 'webmock/test_unit'
WebMock.disable_net_connect!(:allow_localhost => true)

