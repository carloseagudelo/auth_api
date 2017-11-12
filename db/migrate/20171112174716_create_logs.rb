class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.integer :user_id
      t.integer :functionality
      t.string :method
      t.string :error
      t.string :ip
      t.integer :log_type

      t.timestamps
    end
  end
end
