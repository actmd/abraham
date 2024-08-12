# frozen_string_literal: true

require "test_helper"

class Abraham::Test < ActiveSupport::TestCase
  should "modulo abraham activo" do
    assert_kind_of Module, Abraham
  end
end
