class Api::V1::BaseController < ApplicationController
  skip_before_filter :cas_filter
  skip_before_filter AuthenticationFilter
  skip_before_filter :check_user
  skip_before_filter :current_user
  skip_before_filter :log_user
  before_filter :restrict_access
  respond_to :json
  
  protected
  
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      api_key = ApiKey.find_by_access_token(token)
      @user = api_key.user if api_key
      ApiKey.exists?(access_token: token)
    end
  end
end