# frozen_string_literal: true

require "test_helper"

class Foobar::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "home should have home tour code" do
    get foobar_dashboard_home_url
    assert_response :success

    assert_select "body script" do |element|
      # it's the Foobar module home tour
      assert element.text.include? "This tour should appear for the Foobar::DashboardController only"
    end
  end
end
