class Specialty < ApplicationRecord
    has_and_belongs_to_many :posts, join_table: "post_specialties"

    has_many :physician_specialties, dependent: :destroy
    has_many :users, through: :physician_specialties
end
