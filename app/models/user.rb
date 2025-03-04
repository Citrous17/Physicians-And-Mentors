class User < ApplicationRecord
  has_secure_password
  # TODO: Add user id in creation of user automatically
  #validates :user_id, presence: true
  # TODO: Validate other fields.  OAuth does not seem to create these fields automatically
  validates :email, presence: true

  def self.from_omniauth(auth)
    user = where(user_id: auth.uid.to_s, provider: auth.provider).first

    if user.nil?
      # If no user is found, create a new user
      user = User.create!(
        first_name: auth.info.first_name || "",
        last_name: auth.info.last_name || "",
        email: auth.info.email,
        profile_image_url: auth.info.image,
        user_id: auth.uid.to_s,
        provider: auth.provider,
        password_digest: 'password', # Dummy password
        isAdmin: true
      )
    end

    user
  end
end
