class User < ApplicationRecord
  has_secure_password # Enables password hashing

  has_and_belongs_to_many :specialties, join_table: "physician_specialties"


  # ONLY PROFESSIONALS CAN HAVE SPECIALTIES
  before_save :clear_specialties_if_not_professional
  
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, presence: true, on: :create  # Only required on creation

  scope :professionals, -> { where(isProfessional: true) }
  
  def full_name
    "#{first_name} #{last_name}"
  end

  def clear_specialties_if_not_professional
    self.specialties.clear unless isProfessional?
  end

  def self.from_omniauth(auth)
    user = where(user_id: auth.uid, provider: auth.provider).first_or_initialize do |new_user|
      new_user.first_name = auth.info.first_name || ""
      new_user.last_name = auth.info.last_name || ""
      new_user.email = auth.info.email
      new_user.profile_image_url = auth.info.image
      new_user.user_id = auth.uid.to_s
      new_user.provider = auth.provider
      new_user.password = SecureRandom.hex(16)  # Generate a random password for OAuth users
      new_user.isProfessional = false
      new_user.isAdmin = true
    end

    user.save! if user.new_record?  # Save only if the user was newly created
    user
  end

  private

  def validate_invite_code
    invite = InviteCode.find_by(code: invite_code, used: false)

    if invite&.expires_at&.> Time.current
      invite.update(used: true, user_id: self.id)
      self.isProfessional = true # Mark user as professional
    else
      errors.add(:invite_code, "is invalid or expired")
      throw(:abort)
    end
  end
end
