# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                                    :bigint           not null, primary key
#  email_address                         :string           not null
#  kabob_access_token(Kabob平台存取令牌) :string
#  password_digest                       :string           not null
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#
require "net/http"
require "net/https"
require "json"

class User < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :publishers_users, dependent: :destroy
  has_many :publishers, through: :publishers_users

  # validations ...............................................................
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # callbacks .................................................................
  def self.find_or_create_from_kabob(access_token)
    kabob_user = fetch_kabob_user(access_token)
    return nil unless kabob_user

    user = find_or_initialize_by(email_address: "#{kabob_user["id"]}@kabob.conector.io")

    if user.new_record?
      # random password
      user.password = SecureRandom.hex(10)
      user.save!
    end

    if new_token = fetch_new_access_token(access_token)
      user.kabob_access_token = new_token
      user.save!
    end

    user
  end

  def self.fetch_kabob_user(access_token)
    uri = URI("#{ENV["INTERNAL_KABOB_PLATFORM_URL"]}/api/app/v1/user")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"

    req = Net::HTTP::Get.new(uri)
    req["Authorization"] = "Bearer #{access_token}"
    req["Content-Type"] = "application/json; charset=utf-8"
    req.body = "{}"

    response = http.request(req)

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      Rails.logger.error "Kabob API error: #{response.code} - #{response.body}"
      nil
    end
  rescue StandardError => e
    Rails.logger.error "Kabob API request failed: #{e.message}"
    nil
  end

  def self.fetch_new_access_token(access_token)
    uri = URI("#{ENV['INTERNAL_KABOB_PLATFORM_URL']}/api/app/v1/users/new_access_token")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"

    req = Net::HTTP::Get.new(uri)
    req["Authorization"] = "Bearer #{access_token}"
    req["Content-Type"] = "application/json; charset=utf-8"

    response = http.request(req)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      data["access_token"]
    else
      Rails.logger.error "Kabob new token API error: #{response.code} - #{response.body}"
      nil
    end
  rescue StandardError => e
    Rails.logger.error "Kabob new token API request failed: #{e.message}"
    nil
  end

  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  def jwt_token
    JWT.encode({ id: id }, Rails.application.credentials.secret_key_base, "HS256")
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
