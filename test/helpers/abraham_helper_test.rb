# frozen_string_literal: true

require "test_helper"

class AbrahamHelperTest < ActionDispatch::IntegrationTest
  setup do
    @password = 'password'
    @user = users(:normal)
    @employee = @user.employees.first!
    post user_session_url, params: { user: { email: @user.email, password: @password }}
    feature_flag :habilitar_portal_colaborador_v2, true
    I18n.locale = :es
  end

  should "Usar configuracion de ShepherdJS como nil" do
    # No options
    Rails.configuration.abraham.tour_options = nil
    get_with_layout static_pages_portal_url
    assert_response :success
    assert_select ".wrapper .content script" do |element|
      # No options passed into Tour()
      assert_includes(element.text, "new Shepherd.Tour()")
    end
  end

  should "Usar configuracion personalizada en ShepherdJS" do
    # Custom options
    Rails.configuration.abraham.tour_options = '{ defaultStepOptions: { classes: "my-custom-class" } }'
    get_with_layout static_pages_portal_url
    assert_select ".wrapper .content script" do |element|
      # Config-specified options passed into Tour()
      assert_includes(element.text, 'new Shepherd.Tour({ defaultStepOptions: { classes: "my-custom-class" } })')
    end
  end

  should "Generar tours en portal de colaborador" do
    get_with_layout static_pages_portal_url
    assert_response :success

    assert_select ".wrapper .content script" do |element|
      # Has desktop tour
      assert_includes(element.text, "portal-colaborador")
      # Has mobile tour
      assert_includes(element.text, "portal-colaborador-mobile")
      assert_includes(element.text, "controller_name: 'static_pages'")
      assert_includes(element.text, "action_name: 'portal'")
      assert_includes(element.text, "tour_name: 'portal-colaborador'")
    end
  end

  should "Generar botones por defecto" do
    get_with_layout static_pages_portal_url
    assert_response :success
    assert_select '.wrapper .content script' do |element|
      # Desktop
      assert_includes(element.text, "text: 'Siguiente', action: Abraham.tours[\"portal-colaborador\"].next, classes: 'btn-secondary'")
      assert_includes(element.text, "'Atrás', action: Abraham.tours[\"portal-colaborador\"].back, classes: 'btn-primary ghost'")
      # Mobile
      assert_includes(element.text, "text: 'Siguiente', action: Abraham.tours[\"portal-colaborador-mobile\"].next, classes: 'btn-secondary'")
      assert_includes(element.text, "'Atrás', action: Abraham.tours[\"portal-colaborador-mobile\"].back, classes: 'btn-primary ghost'")
    end
  end

  should "Generar botones de inicio y fin del tour" do
    get_with_layout static_pages_portal_url
    assert_response :success
    assert_select '.wrapper .content script' do |element|
      # Desktop
      assert_includes(element.text, "'Ver después', action: Abraham.tours[\"portal-colaborador\"].cancel, classes: 'btn-primary ghost'")
      assert_includes(element.text, "text: 'Cerrar', action: Abraham.tours[\"portal-colaborador\"].complete, classes: 'btn-secondary'")
      # Mobile
      assert_includes(element.text, "'Ver después', action: Abraham.tours[\"portal-colaborador-mobile\"].cancel, classes: 'btn-primary ghost'")
      assert_includes(element.text, "text: 'Cerrar', action: Abraham.tours[\"portal-colaborador-mobile\"].complete, classes: 'btn-secondary'")
    end
  end
end
