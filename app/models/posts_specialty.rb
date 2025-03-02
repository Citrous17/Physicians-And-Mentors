class PostsSpecialty < ApplicationRecord
  belongs_to :post
  belongs_to :specialty
end
