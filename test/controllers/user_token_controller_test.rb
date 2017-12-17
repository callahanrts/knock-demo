require 'test_helper'

class UserTokenControllerTest < ActionDispatch::IntegrationTest

  def parse_jwt
    JSON.parse(@response.body)["jwt"]
  end

  setup do
    @user = User.create(email: "1@user.com", password: "password")
  end

  test "should log in a user and return a non-nil jwt" do
    post user_token_url({
      auth: {
        email: @user.email,
        password: @user.password
      }
    })
    assert_response :success
    assert_not_nil parse_jwt
  end

end
