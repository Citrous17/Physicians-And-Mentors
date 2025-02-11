class PostSpecialty < ApplicationRecord
    belongs_to :post
    belongs_to :specialty
  end