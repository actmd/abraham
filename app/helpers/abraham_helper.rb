# frozen_string_literal: true

module AbrahamHelper
  def abraham_tour
    # Do we have tours for this controller/action in the user's locale?
    tours = Rails.configuration.abraham.tours["#{controller_path}.#{action_name}.#{I18n.locale}"]
    # Otherwise, default to the default locale
    tours ||= Rails.configuration.abraham.tours["#{controller_path}.#{action_name}.#{I18n.default_locale}"]

    if tours
      # Have any automatic tours been completed already?
      completed = Abraham::History.where(
        creator_id: current_user.id,
        controller_name: controller_path,
        action_name: action_name
      )

      tour_keys_completed = completed.map(&:tour_name)
      tour_keys = tours.keys

      tour_html = ''

      tour_keys.each do |key|
        tour_html += render(partial: 'application/abraham',
                            locals: { tour_name: key,
                                      tour_completed: tour_keys_completed.include?(key),
                                      trigger: tours[key]['trigger'],
                                      steps: tours[key]['steps'] })
      end

      tour_html.html_safe
    end
  end

  def abraham_cookie_prefix
    "abraham-#{fetch_application_name.to_s.underscore}-#{current_user.id}-#{controller_path}-#{action_name}"
  end

  def fetch_application_name
    if Module.method_defined?(:module_parent)
      Rails.application.class.module_parent
    else
      Rails.application.class.parent
    end
  end

  def abraham_domain
    request.host
  end
end
