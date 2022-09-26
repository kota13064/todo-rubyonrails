class ApplicationController < ActionController::Base
  include UserSessionsHelper

  rescue_from ActiveRecord::RecordNotFound, with: :render404

  def render404
    render file: 'public/404.html', status: :not_found, content_type: 'text/html'
  end
end
