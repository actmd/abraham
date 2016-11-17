module AbrahamHelper
  def abraham_tour
    # Do we have tours for this controller/action in the user's locale?
    tours = Rails.configuration.abraham["#{controller_name}.#{action_name}.#{I18n.locale}"]

    unless tours
      # How about the default locale?
      tours = Rails.configuration.abraham["#{controller_name}.#{action_name}.#{I18n.default_locale}"]
    end

    if tours
      completed = AbrahamHistory.where(
          creator: @current_person, controller_name: controller_name,
          action_name: action_name)
      remaining = tours.keys - completed.map(&:tour_name)

      if remaining.any?
        # Generate the javascript snippet for the next remaining tour
        render(:partial => 'application/tour',
               :locals => {:tour_name => remaining.first,
                           :steps => tours[remaining.first]['steps']})
      end
    end
  end
end
