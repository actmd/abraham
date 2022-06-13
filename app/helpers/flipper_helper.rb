# frozen_string_literal: true

module FlipperHelper
  def should_add_tour(flipper_key, flipper_activation)
    case process_activation_option(flipper_activation)
    when "enabled"
      return (flipper_key && flipper_enabled?(key)) || flipper_key.nil?
    when "disabled"
      return (flipper_key && flipper_disabled?(key)) || flipper_key.nil?
    else
      return false
    end
  end

  private
    def flipper_defined?
      Object.const_defined?("Flipper")
    end

    def flipper_enabled?(key)
      flipper_defined? && Flipper.enabled?(key.to_sym)
    end

    def flipper_disabled?(key)
      flipper_defined? && Flipper.disabled?(key.to_sym)
    end

    def process_activation_option(flipper_activation)
      return "disabled" if flipper_activation == "disabled"
      "enabled"
    end
end
