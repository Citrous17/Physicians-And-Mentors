class Specialty < ApplicationRecord
    has_and_belongs_to_many :posts, join_table: "post_specialties"
    has_and_belongs_to_many :users, join_table: "physician_specialties"


end
