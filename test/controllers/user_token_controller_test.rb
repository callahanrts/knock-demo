require 'test_helper'

class UserTokenControllerTest < ActionDispatch::IntegrationTest

  def parse_jwt
    JSON.parse(@response.body)["jwt"]
  end

  setup do
    @user = User.create(email: "1@user.com", password: "password")

    post user_token_url({
      auth: {
        email: @user.email,
        password: @user.password
      }
    })
  end

  test "the response is successful" do
    assert_response :success
  end

  test 'it returns a non-nil jwt' do
    assert_not_nil parse_jwt
  end

end
