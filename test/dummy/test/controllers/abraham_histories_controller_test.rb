# frozen_string_literal: true

require "test_helper"

class AbrahamHistoriesControllerTest < ActionDispatch::IntegrationTest
  test "should create AbrahamHistory" do
    assert_difference ["AbrahamHistory.count"] do
      post abraham_histories_url, as: :json, params: { abraham_history: { action_name: "foo", controller_name: "bar", tour_name: "baz" } }
    end
  end
end
