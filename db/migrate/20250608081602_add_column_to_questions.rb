class AddColumnToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :correct, :string, null: false, default: ""
  end
end
