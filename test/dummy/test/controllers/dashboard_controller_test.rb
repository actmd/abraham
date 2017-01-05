# frozen_string_literal: true
require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test 'uses configured shepherd theme' do
    # default
    get dashboard_home_url
    assert_response :success
    assert_select 'body script' do |element|
      # it's the home tour
      assert element.text.include? "classes: 'shepherd-theme-default'"
    end

    # custom
    Rails.configuration.abraham.default_theme = 'my-custom-theme'
    get dashboard_home_url
    assert_select 'body script' do |element|
      # it's the home tour
      assert element.text.include? "classes: 'my-custom-theme'"
    end
  end

  test 'home should have home tour code' do
    get dashboard_home_url
    assert_response :success

    assert_select 'body script' do |element|
      # it's the home tour
      assert element.text.include? 'ENGLISH This first HOME step is centered text-only'
      # it has three steps
      assert element.text.include? 'step-1'
      assert element.text.include? 'step-2'
      assert element.text.include? 'step-3'
      assert element.text.include? 'step-4'
      # Generates a showOn option
      assert element.text.include? 'showOn:'
      # it will post the right completion information
      assert element.text.include? "controller_name: 'dashboard'"
      assert element.text.include? "action_name: 'home'"
      assert element.text.include? "tour_name: 'intro'"
    end
  end

  test 'other should have other tour code' do
    get dashboard_other_url
    assert_response :success

    assert_select 'body script' do |element|
      # it's the home tour
      assert element.text.include? 'TOUR ONE step one ENGLISH'
      # it has only one steps
      assert element.text.include? 'step-1'
      # it will post the right completion information
      assert element.text.include? "controller_name: 'dashboard'"
      assert element.text.include? "action_name: 'other'"
      assert element.text.include? "tour_name: 'tour_one'"
    end
  end
end
