require "test_helper"

class ForgotPasswordControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get forgot_password_new_url
    assert_response :success
  end

  test "should get create" do
    get forgot_password_create_url
    assert_response :success
  end
end
