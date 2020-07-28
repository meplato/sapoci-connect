# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

class ApiTest < SAPOCI::Connect::TestCase

  def test_api_responds_to_well_known_methods
    assert SAPOCI::Connect.respond_to?(:search)
  end

end
