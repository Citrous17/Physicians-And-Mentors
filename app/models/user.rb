class User < ApplicationRecord
  has_secure_password # Enables password hashing

  has_and_belongs_to_many :specialties, join_table: "physician_specialties"


  # ONLY PROFESSIONALS CAN HAVE SPECIALTIES
  before_save :clear_specialties_if_not_professional
  
  validates :email, presence: true
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

  def has_password?
    password_digest.present?
  end
  


  def self.from_omniauth(auth)
    # if signing in with google oauth, and for the first time, create a new user, which is NON PROFESSIONAL BY DEFAULT
    user = where(oauth_uid: auth.uid, provider: auth.provider).first_or_initialize do |new_user|
      new_user.first_name = auth.info.first_name || ""
      new_user.last_name = auth.info.last_name || ""
      new_user.email = auth.info.email
      new_user.profile_image_url = auth.info.image
      new_user.oauth_uid = auth.uid.to_s
      new_user.provider = auth.provider
      new_user.password = SecureRandom.hex(16)  # Generate a random password for OAuth users
      new_user.isProfessional = false
      new_user.isAdmin = false
      new_user.DOB = nil
      new_user.phone_number = nil
      new_user.isProfessional = false
    end
  
    is_new_user = user.new_record?  # Check if it's a new oauth user before saving
    user.save! if is_new_user # If it is an oauth user with no previous profile, save
  
    return { user: user, new_user: is_new_user } # Return both user and status, as a Hash
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
