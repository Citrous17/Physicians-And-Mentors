class Post < ApplicationRecord
  belongs_to :sending_user, class_name: "User"  # Assuming User model exists
  belongs_to :parent_post, class_name: "Post", optional: true  # For threaded replies

  validates :title, presence: true
  validates :content, presence: true
  validates :sending_user_id, presence: true

  has_many :replies, class_name: "Post", foreign_key: "parent_post_id", dependent: :destroy
end