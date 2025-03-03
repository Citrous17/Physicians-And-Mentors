class User < ApplicationRecord
  has_secure_password
  # TODO: Add user id in creation of user automatically
  #validates :user_id, presence: true
  # TODO: Validate other fields.  OAuth does not seem to create these fields automatically
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :DOB, presence: true
  validates :phone_number, presence: true
  validates :isProfessional, inclusion: { in: [true, false] }

  def self.from_omniauth(auth)
    user = where(user_id: auth.uid, provider: auth.provider).first_or_initialize do |new_user|
      new_user.first_name = auth.info.first_name || ""
      new_user.last_name = auth.info.last_name || ""
      new_user.email = auth.info.email
      new_user.name = auth.info.name
      new_user.profile_image_url = auth.info.image
      new_user.user_id = auth.uid.to_s
      new_user.provider = auth.provider
      new_user.password = SecureRandom.hex(16)  # Generate a random password for OAuth users
    end

    user.save! if user.new_record?  # Save only if the user was newly created
    user
  end
end

