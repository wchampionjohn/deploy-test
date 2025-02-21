class IndexController < ApplicationController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access
  def index
  end
end
