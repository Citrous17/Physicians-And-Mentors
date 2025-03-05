class Post < ApplicationRecord
  belongs_to :sending_user, class_name: "User", foreign_key: "sending_user_id"  # Assuming User model exists
  
  has_many :posts_specialties, dependent: :destroy
  has_and_belongs_to_many :specialties, join_table: "post_specialties"

  validates :title, presence: true
  validates :content, presence: true
  validates :sending_user_id, presence: true
end