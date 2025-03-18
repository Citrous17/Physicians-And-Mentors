class User < ApplicationRecord
  has_secure_password # Enables password hashing
  
  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password_digest, presence: true, on: :create  # Only required on creation
  validates :isProfessional, inclusion: { in: [true, false] }

  scope :professionals, -> { where(isProfessional: true) }
  
  def full_name
    "#{first_name} #{last_name}"
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

      new_user.DOB = nil
      new_user.phone_number = nil
      new_user.isProfessional = false
    end
  
    is_new_user = user.new_record?  # Check if it's a new oauth user before saving
    user.save! if is_new_user # If it is an oauth user with no previous profile, save
  
    return { user: user, new_user: is_new_user } # Return both user and status, as a Hash
  end
  
end