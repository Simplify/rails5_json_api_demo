class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.timestamps
      t.string     :title
      t.text       :content
      t.integer    :user_id
      t.string     :category
      t.integer    :rating
    end
  end
end
