# frozen_string_literal: true

# Helper para habilitar FF en tour guiado
module FlipperHelper
  def should_add_tour(flipper_key, flipper_activation)
    return true if !flipper_defined?

    case process_activation_option(flipper_activation)
    when "enabled"
      return (flipper_key && Buk::Feature.enabled?(flipper_key.to_sym)) || flipper_key.nil?
    when "disabled"
      return (flipper_key && !Buk::Feature.enabled?(flipper_key.to_sym)) || flipper_key.nil?
    else
      return false
    end
  end

  private
    def flipper_defined?
      Object.const_defined?("Flipper")
    end

    def process_activation_option(flipper_activation)
      return "disabled" if flipper_activation == "disabled"
      "enabled"
    end
end
