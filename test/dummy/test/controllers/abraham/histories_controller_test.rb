# frozen_string_literal: true

require 'test_helper'

module Abraham
  class HistoriesControllerTest < ActionDispatch::IntegrationTest
    test 'creates Abraham::History' do
      assert_difference ['Abraham::History.count'] do
        post abraham.histories_url, as: :json, params: { history: { action_name: 'foo', controller_name: 'bar', tour_name: 'baz' } }
      end
    end
  end
end
