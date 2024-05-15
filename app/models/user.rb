class User < ApplicationRecord
  validates :name, presence: true
  has_many :sns_credentials, dependent: :destroy

  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :omniauthable,
          omniauth_providers: [:line, :google_oauth2]

  def self.from_omniauth(auth)
    sns_credential = SnsCredential.find_by(provider: auth.provider, uid: auth.uid)
    if sns_credential && sns_credential.user
      user = sns_credential.user
    else
      email = auth.info.email || "user_#{auth.uid}@example.com"
      user = User.where(email: email).first_or_initialize do |u|
        u.email = email
        u.name = auth.info.name || "LINE User"
        u.password = Devise.friendly_token[0, 20]
      end
      user.save! if user.new_record?
      user.sns_credentials.find_or_create_by(uid: auth.uid, provider: auth.provider)
    end
    user
  end
end
