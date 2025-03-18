class InviteCode < ApplicationRecord
    belongs_to :user, optional: true 
    before_create :generate_unique_code
    scope :active, -> { where(used: false).where("expires_at > ?", Time.current) }
  
    def user_email
        self[:user_email] || 'Not Assigned'
    end      

    private
  
    def generate_unique_code
      self.code ||= SecureRandom.hex(8)
      self.expires_at ||= 7.days.from_now
    end
  end
  