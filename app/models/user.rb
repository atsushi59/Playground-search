class User < ApplicationRecord
  validates :name, presence: true

  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable
end
