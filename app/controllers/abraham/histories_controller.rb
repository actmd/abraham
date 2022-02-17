# frozen_string_literal: true

class Abraham::HistoriesController < ApplicationController
  def create
    abraham_history = Abraham::History.new(abraham_history_params).tap do |history|
      history.creator_id = current_user.id
    end

    respond_to do |format|
      if abraham_history.save
        format.json { render json: abraham_history, status: :created }
      else
        format.json { render json: abraham_history.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def abraham_history_params
    params.require(:history).permit(:controller_name, :action_name, :tour_name)
  end
end
