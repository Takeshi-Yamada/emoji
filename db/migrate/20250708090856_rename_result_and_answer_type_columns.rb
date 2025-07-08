class RenameResultAndAnswerTypeColumns < ActiveRecord::Migration[8.0]
  def change
    rename_column :answers, :result, :is_result
    rename_column :questions, :answer_type, :answer_category
  end
end
