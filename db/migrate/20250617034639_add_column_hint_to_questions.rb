class AddColumnHintToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :hint, :string
    add_column :questions, :answer_type, :integer, default: 0
  end
end
