require 'test_helper'
require 'culqi/version'

class CulqiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Culqi::VERSION
  end
end
