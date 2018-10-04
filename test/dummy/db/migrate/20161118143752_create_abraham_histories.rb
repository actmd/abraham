# frozen_string_literal: true

class CreateAbrahamHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :abraham_histories do |t|
      t.string :controller_name
      t.string :action_name
      t.string :tour_name
      t.references :creator, null: false, index: true

      t.timestamps index: true
    end
  end
end
