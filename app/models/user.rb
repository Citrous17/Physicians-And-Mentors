class User < ApplicationRecord
  has_secure_password # Enables password hashing

  has_and_belongs_to_many :specialties, join_table: "physician_specialties"


  # ONLY PROFESSIONALS CAN HAVE SPECIALTIES
  before_save :clear_specialties_if_not_professional

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, presence: true, on: :create  # Only required on creation
  validates :isProfessional, inclusion: { in: [true, false] }

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
    return nil if auth.nil? || auth.uid.blank? || auth.provider.blank?

    user = User.find_by(oauth_uid: auth.uid, provider: auth.provider) || User.find_by(email: auth.info.email)

    if user
      user.update(
        oauth_uid: auth.uid,
        provider: auth.provider,
        profile_image_url: auth.info.image
      )
      is_new_user = false
    else
      user = User.create!(
        first_name: auth.info.first_name,
        last_name: auth.info.last_name,
        email: auth.info.email,
        oauth_uid: auth.uid,
        provider: auth.provider,
        profile_image_url: auth.info.image,
        password: SecureRandom.hex(16),
        DOB: auth.info.DOB || nil,
        phone_number: auth.info.phone_number || nil,
        isProfessional: false
      )
      is_new_user = true
    end

    { user: user, new_user: is_new_user }
  end
end
