# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: true
  has_many :places, dependent: :destroy
  has_many :places_favorites, dependent: :destroy
  has_many :place_histories, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :reviews_likes, dependent: :destroy
  has_many :review_favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :sns_credentials, dependent: :destroy
  mount_uploader :avatar, UserImageUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: %i[line google_oauth2]

  def self.from_omniauth(auth)
    sns_credential = SnsCredential.find_by(provider: auth.provider, uid: auth.uid)
    return sns_credential.user if sns_credential&.user

    email = auth.info.email || "user_#{auth.uid}@example.com"
    user = find_or_initialize_user(auth, email)
    create_sns_credential(user, auth) if user.new_record?
    user
  end

  def self.find_or_initialize_user(auth, email)
    User.where(email:).first_or_initialize do |user|
      user.email = email
      user.name = auth.info.name || 'LINE User'
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.create_sns_credential(user, auth)
    user.save!
    user.sns_credentials.find_or_create_by(uid: auth.uid, provider: auth.provider)
  end
end
