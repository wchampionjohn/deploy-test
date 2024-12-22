class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  private

  def authenticate_user!
    return if authenticated_user.present?
    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def authenticated_user
    @authenticate_user ||= begin
      token = request.headers["Authorization"]&.split(" ")&.last
      return nil unless token

      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: "HS256" })
      User.find(decoded_token[0]["id"])
    rescue JWT::DecodeError
      nil
    end
  end

  def current_user
    @current_user ||= authenticated_user
  end
end
