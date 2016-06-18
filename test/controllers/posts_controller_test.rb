require 'test_helper'
require 'json'

class PostsControllerTest < ActionController::TestCase

  test "Should get valid list of posts" do
    get :index, params: { page: { number: 2 } }
    assert_response :success
    jdata = JSON.parse response.body
    assert_equal Post.per_page, jdata['data'].length
    assert_equal jdata['data'][0]['type'], 'posts'
    l = jdata['links']
    assert_equal l['first'], l['prev']
    assert_equal l['last'], l['next']
    assert_equal Post.count, jdata['meta']['total-count']
    assert_equal 'CC-0', jdata['meta']['licence']
  end

  test "Should get properly sorted list" do
    post = Post.order('rating DESC').first
    get :index, params: { sort: '-rating' }
    assert_response :success
    jdata = JSON.parse response.body
    assert_equal post.title, jdata['data'][0]['attributes']['title']
  end

  test "Should get filtered list" do
    get :index, params: { filter: 'First' }
    assert_response :success
    jdata = JSON.parse response.body
    assert_equal Post.where(category: 'First').count, jdata['data'].length
  end

  test "Should get valid post data" do
    post = posts('article_0_0')
    get :show, params: { id: post.id }
    assert_response :success
    jdata = JSON.parse response.body
    assert_equal post.id.to_s, jdata['data']['id']
    assert_equal post.title, jdata['data']['attributes']['title']
    assert_equal post_url(post, { host: "localhost", port: 3000 }), jdata['data']['links']['self']
  end

  test "Should get JSON:API error block when requesting post data with invalid ID" do
    get :show, params: { id: "z" }
    assert_response 404
    jdata = JSON.parse response.body
    assert_equal "Wrong ID provided", jdata['errors'][0]['detail']
    assert_equal '/data/attributes/id', jdata['errors'][0]['source']['pointer']
  end

  test "Creating new post with valid data should create new post" do
    user = users('user_1')
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    @request.headers["X-Api-Key"] = user.token
    post :create, params: { data: { type: 'posts', attributes: { title: 'New Title',
                                                                 content: "New content",
                                                                 rating: '8',
                                                                 category: 'Testing2',
                                                                 user_id: user.id }}}
    assert_response 201
    jdata = JSON.parse response.body
    assert_equal 'New Title', jdata['data']['attributes']['title']
  end

  test "Updating an existing post with valid data should update that post" do
    post = posts('article_0_0')
    user = users('user_1')
    @request.headers["Content-Type"] = 'application/vnd.api+json'
    @request.headers["X-Api-Key"] = user.token
    patch :update, params: {
            id: post.id,
            data: {
              id: post.id,
              type: 'posts',
              attributes: {
                title: 'New Title' }}}
    assert_response 200
    jdata = JSON.parse response.body
    assert_equal 'New Title', jdata['data']['attributes']['title']
  end

  test "Should delete post" do
    user = users('user_1')
    pcount = Post.count - 1
    @request.headers["X-Api-Key"] = user.token
    delete :destroy, params: { id: posts('article_5_24').id }
    assert_response 204
    assert_equal pcount, Post.count
  end

end