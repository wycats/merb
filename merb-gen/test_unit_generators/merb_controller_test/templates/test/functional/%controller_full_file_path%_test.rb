require File.join(File.dirname(__FILE__), "<%= Array.new((controller_modules.size + 1),'..').join("/") %>",'test_helper')

# Re-raise errors caught by the controller.
class <%= full_controller_const %>; def rescue_action(e) raise e end; end

class <%= full_controller_const %>Test < Test::Unit::TestCase

  def setup
    @controller = <%= full_controller_const %>.build(fake_request)
    @controller.dispatch('index')
  end

  # Replace this with your real tests.
  def test_should_be_setup
    assert false
  end
end