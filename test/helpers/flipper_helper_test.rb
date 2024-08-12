# frozen_string_literal: true

require "test_helper"

class FlipperHelperTest < ActionView::TestCase
  context "Cuando el tour requiera un FF activo" do
    setup do
      @show_tour_on = "enabled"
    end

    should "Mostrar tour con FF activo" do
      feature_flag :foo, true
      assert should_add_tour("foo", @show_tour_on)
    end

    should "Ocultar tour con FF inactivo" do
      feature_flag :foo, false
      assert_not should_add_tour("foo", @show_tour_on)
    end
  end

  context "Cuando el tour requiera un FF inactivo" do
    setup do
      @show_tour_on = "disabled"
    end

    should "Mostrar tour con FF inactivo" do
      feature_flag :foo, false
      assert should_add_tour("foo", @show_tour_on)
    end

    should "Ocultar tour con FF activo" do
      feature_flag :foo, true
      assert_not should_add_tour("foo", @show_tour_on)
    end
  end
end
