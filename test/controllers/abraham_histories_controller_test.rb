# frozen_string_literal: true

require "test_helper"

class AbrahamHistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @password = 'password'
    @user = users(:normal)
    @employee = @user.employees.first!
    post user_session_url, params: { user: { email: @user.email, password: @password }}
  end

  should "Crear registro en AbrahamHistory" do
    assert_difference ["AbrahamHistory.count"] do
      post abraham_histories_url, as: :json, params: { action_name: "foo", controller_name: "bar", tour_name: "baz" }
    end
  end
end
