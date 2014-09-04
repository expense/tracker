class ApplicationController < ActionController::Base
  respond_to :html, :json
  protect_from_forgery with: :null_session
  before_filter :require_api_key
  after_filter :cors

  def require_api_key
    render "security/unauthorized" unless params[:api_key] == ENV['API_KEY'] || cookies[:API_KEY] == ENV['API_KEY']
  end

  def cors
    response.headers['Access-Control-Allow-Origin'] = '*'
  end
end
