# frozen_string_literal: true

require 'httparty'

Geocoder.configure(
  lookup: :google,
  api_key: ENV['GOOGLE_API_KEY'],
  use_https: true
)
