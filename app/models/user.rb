class User < ApplicationRecord
  def self.from_omniauth(auth)
    user = where(user_id: auth.uid, provider: auth.provider).first

    if user.nil?
      # If no user is found, create a new user
      user = User.create!(
        first_name: auth.info.first_name || "",
        last_name: auth.info.last_name || "",
        email: auth.info.email,
        name: auth.info.name,
        profile_image_url: auth.info.image,
        user_id: auth.uid,
        provider: auth.provider
      )
    end

    user
  end
end
