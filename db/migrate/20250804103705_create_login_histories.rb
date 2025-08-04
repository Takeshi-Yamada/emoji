class CreateLoginHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :login_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.date :logged_in_on, null: false

      t.timestamps
    end
    add_index :login_histories, [:user_id, :logged_in_on], unique: true
  end
end
