require 'test_helper'

class StatusControllerTest < ActionDispatch::IntegrationTest

  # Parse the response and return a specific key
  def parse_response(key)
    JSON.parse(@response.body)[key.to_s]
  end

  # Log a user in and return the valid JWT
  def log_in
    post user_token_url({
      auth: {
        email: @user.email,
        password: @user.password
      }
    })

    parse_response(:jwt)
  end

  setup do
    @user = User.create(email: "1@user.com", password: "password")
  end

  # A non-logged in user should get an unauthorized request response
  test "#index unauthorized requests return :unauthorized" do
    get status_index_url
    assert_response :unauthorized
  end

  test "#index should return a logged in message when a user is logged in" do
    # Users are authorized by sending the JWT in the Authorization header
    get status_index_url, headers: { "Authorization" => "Bearer #{log_in}"}
    assert_response :success
    assert_equal 'logged in', parse_response(:message)
  end

  # The #user action should return a nil user when no one is logged in
  test "#user non logged-in user should be nil" do
    get user_status_index_url
    assert_nil parse_response(:user)
  end

  # The #user action should return a user (email, check the as_json method in the user model
  # of the linked github repository for how to make sure you're not returning too much user data)
  test '#user returns the logged in user' do
    get user_status_index_url, headers: { "Authorization" => "Bearer #{log_in}"}
    assert_equal @user.email, parse_response(:user)['email']
  end

  test '#user returns a refreshed jwt' do
    get user_status_index_url, headers: { "Authorization" => "Bearer #{log_in}"}
    jwt = parse_response(:jwt)
    # Assert the first token is not nil
    assert_not_nil jwt

    # Generating an auth token seems to use a timestamp, so wait a second
    # before generating another one
    sleep 1

    get user_status_index_url, headers: { "Authorization" => "Bearer #{log_in}"}
    # Assert the second token is not nil
    assert_not_nil parse_response(:jwt)

    # Assert the second token does not equal the first
    assert_not_equal jwt, parse_response(:jwt)
  end
end

