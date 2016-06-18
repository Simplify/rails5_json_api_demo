class Post < ApplicationRecord
  belongs_to :user
  self.per_page = 50

  validates_presence_of :title, :content, :category, :rating

end