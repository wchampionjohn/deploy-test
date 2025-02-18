# frozen_string_literal: true

module ApplicationHelper
  def creative_loaded_url
    ENV["CONNECTOR_API_URL"] + "/creative_loaded"
  end

  def burl
    ENV["CONNECTOR_API_URL"] + "/burl"
  end
end
