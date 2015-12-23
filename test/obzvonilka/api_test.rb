require 'test_helper'

class Obzvonilka::ApiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Obzvonilka::Api::VERSION
  end

end
