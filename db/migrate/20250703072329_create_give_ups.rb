class CreateGiveUps < ActiveRecord::Migration[8.0]
  def change
    create_table :give_ups do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
    add_index :give_ups, [:user_id, :question_id], unique: true
  end
end
