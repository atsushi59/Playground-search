# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'name' }
    email { 'user@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
