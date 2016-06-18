class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.timestamps
      t.string     :full_name
      t.string     :password_digest
      t.string     :token
      t.text       :description
    end
    add_index :users, :token, unique: true
  end
end
