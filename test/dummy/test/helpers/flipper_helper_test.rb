# frozen_string_literal: true

require "test_helper"

class FlipperHelperTest < ActionView::TestCase
  test "Add tour whenever all options nil" do
  	assert should_add_tour(nil, nil)
  end

  test "Add tour whenever Flipper is disabled " do
  	# Flipper is not enabled, so tour should be added regardless of options
  	assert should_add_tour("foo", "enabled")
  	assert should_add_tour("foo", "disabled")
  end

  test "Respect Flipper results if Flipper enabled" do
    mockFlipper = Object.new
    mockFlipper.stubs(:enabled?).returns(true)
    
    Kernel.const_set('Flipper', mockFlipper)
    assert_equal Flipper, mockFlipper

    assert should_add_tour("foo", "enabled")
    refute should_add_tour("foo", "disabled")

    mockFlipper.stubs(:enabled?).returns(false)

    refute should_add_tour("foo", "enabled")
    assert should_add_tour("foo", "disabled")

    Kernel.send(:remove_const, :Flipper)
  end
end
