class Comment < ApplicationRecord
    before_create :set_time_sent

    def set_time_sent
        self.time_sent = Time.now
    end
    belongs_to :sending_user, class_name: "User"
    belongs_to :parent_post, class_name: "Post", optional: true
end
