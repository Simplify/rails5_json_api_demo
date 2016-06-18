require 'test_helper'
require 'json'

class SessionsControllerTest < ActionController::TestCase

  test "Creating new session with valid data should create new session" do
    user = users('user_0')
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    post :create, params: { data: { type: 'sessions', attributes: { full_name: user.full_name,
                                                                    password: 'password' }}}
    assert_response 201
    jdata = JSON.parse response.body
    refute_equal user.token, jdata['data']['attributes']['token']
  end

  test "Should delete session" do
    user = users('user_0')
    delete :destroy, params: { id: user.token }
    assert_response 204
  end
end