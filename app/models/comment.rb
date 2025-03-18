class Comment < ApplicationRecord
    belongs_to :sending_user, class_name: "User"
    belongs_to :parent_post, class_name: "Post", optional: true
end
  