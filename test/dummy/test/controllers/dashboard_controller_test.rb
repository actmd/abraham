# frozen_string_literal: true

require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    I18n.locale = :en
  end

  teardown do
    I18n.locale = :en
  end

  test "uses configured shepherd configuration" do
    # No options
    Rails.configuration.abraham.tour_options = nil
    get dashboard_home_url
    assert_response :success
    assert_select "body script" do |element|
      # No options passed into Tour()
      assert element.text.include? "new Shepherd.Tour()"
    end

    # Custom options
    Rails.configuration.abraham.tour_options = '{ defaultStepOptions: { classes: "my-custom-class" } }'
    get dashboard_home_url
    assert_select "body script" do |element|
      # Config-specified options passed into Tour()
      assert element.text.include? 'new Shepherd.Tour({ defaultStepOptions: { classes: "my-custom-class" } })'
    end
  end

  test "home should have home tour code" do
    get dashboard_home_url
    assert_response :success

    assert_select "body script" do |element|
      # it's the home tour
      assert element.text.include? "ENGLISH This first HOME step is centered &amp; &#39;text-only&#39;"
      # it has four steps
      assert element.text.include? "step-1"
      assert element.text.include? "step-2"
      assert element.text.include? "step-3"
      assert element.text.include? "step-4"
      # Generates a showOn option
      assert element.text.include? "showOn:"
      # it will post the right completion information
      assert element.text.include? "controller_name: 'dashboard'"
      assert element.text.include? "action_name: 'home'"
      assert element.text.include? "tour_name: 'intro'"
    end
  end

  test "should show tour for locale" do
    I18n.locale = :es
    get dashboard_home_url
    assert_response :success

    assert_select 'body script' do |element|
      # it's the spanish home tour
      assert element.text.include? 'SPANISH This first HOME step is centered text-only'
    end
  end

  test "should show custom buttons for locale" do
    get dashboard_buttons_url
    assert_response :success
    assert_select 'body script' do |element|
      assert element.text.include? 'Show this to me later'
      assert element.text.include? 'Finish now'
    end

    I18n.locale = :es
    get dashboard_buttons_url
    assert_response :success
    assert_select 'body script' do |element|
      assert element.text.include? 'Mas tarde'
      assert element.text.include? 'Ahora'
    end
  end

  test "other should have other tour code" do
    get dashboard_other_url
    assert_response :success

    assert_select "body script" do |element|
      # it's the home tour
      assert element.text.include? "TOUR ONE step one ENGLISH"
      # it has only one steps
      assert element.text.include? "step-1"
      # it will post the right completion information
      assert element.text.include? "controller_name: 'dashboard'"
      assert element.text.include? "action_name: 'other'"
      assert element.text.include? "tour_name: 'tour_one'"
    end
  end
end
