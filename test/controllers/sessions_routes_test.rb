require 'test_helper'

class SessionsRoutesTest < ActionController::TestCase
  test "should route to create session" do
    assert_routing({ method: 'post', path: '/sessions' }, { controller: "sessions", action: "create" })
  end
  test "should route to delete session" do
    assert_routing({ method: 'delete', path: '/sessions/something'}, { controller: "sessions", action: "destroy", id: "something" })
  end
end