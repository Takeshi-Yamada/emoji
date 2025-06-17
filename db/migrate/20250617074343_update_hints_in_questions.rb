class UpdateHintsInQuestions < ActiveRecord::Migration[8.0]
  def change
    rename_column :questions, :hint, :hint_1

    add_column :questions, :hint_2, :string
    add_column :questions, :hint_3, :string
  end
end
