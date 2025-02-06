# frozen_string_literal: true

class Api::AuthorizationsController < Api::BaseController
  allow_unauthenticated_access only: :show

  def show
    if user = User.find_or_create_from_kabob(params[:access_token])
      render json: {
        status: "success",
        user: {
          token: user.jwt_token
        }
      }
    else
      render json: { status: "error", message: "Invalid access token" }, status: :unauthorized
    end
  end
end
