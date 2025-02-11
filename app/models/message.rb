class Message < ApplicationRecord
    belongs_to :sending_user, class_name: 'User'
    belongs_to :receiving_user, class_name: 'User'
    belongs_to :parent_message, class_name: 'Message', optional: true
  end
  