class User < ApplicationRecord
    validates :uid, presence: true
    validates :provider, presence: true
  
    def self.from_omniauth(auth)
      where(uid: auth.uid, provider: auth.provider).first_or_create do |user|
        user.name = auth.info.name
        user.email = auth.info.email
      end
    end
  end