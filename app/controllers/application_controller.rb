require 'common_engine'
require_dependency 'authenticated_system'
require_dependency 'authentication_filter'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include AuthenticatedSystem
  before_filter :cas_filter, :authentication_filter, :check_user, :current_user, :except => ['no', 'destroy', 'logout', 'expire', 'lb']
  before_filter :log_user, :except => [:destroy]

  def self.application_name
    "Infobase"
  end

  def application_name
    ApplicationController.application_name
  end

  protected
  
  def cas_filter
    CASClient::Frameworks::Rails::Filter.filter(self)
  end

  def authentication_filter
    AuthenticationFilter.filter(self)
  end
  
  def check_user
    unless @info_user
      if session[:info_user_id]
        @info_user = InfobaseUser.find(session[:info_user_id])
      elsif session[:info_user_type]
        @info_user = Kernel.const_get(session[:info_user_type]).new
      else
        @info_user = InfobaseUser.determine_infobase_user(current_user(), session[:cas_emplid])
        if @info_user && @info_user.id
          session[:info_user_id] = @info_user.id
        elsif @info_user
          session[:info_user_type] = @info_user.class.to_s
        end
      end
    end
    if @info_user
      @info_user
    else
      redirect_to :controller => :home, :action => :no
      return false
    end
  end

  def current_user
    unless @current_user
      if session[:user_id]
        @current_user = User.find(session[:user_id])
        # developer method to override user in session for testing
        if params[:user_id] && params[:su] && (@current_user.developer? || (session[:old_user_id] && old_user = User.find(session[:old_user_id]).developer?))
          session[:old_user_id] = @current_user.id if @current_user.developer?
          session[:user_id] = params[:user_id]
          @current_user = User.find(session[:user_id])
        end
      end
      if session['cas_extra_attributes']
        @current_user ||= User.find_by_globallyUniqueID(session['cas_extra_attributes']['ssoGuid'])
      end
      if @current_user
        @current_user.create_person_and_address unless @current_user.person
      end
    end
    @current_user
  end

  def log_user
    logger.info "User is " + current_user.username.to_s if current_user
  end

  def search_options
    @search_types = {"Location" => "locations", "Person" => "people", "Team" => "teams"}
    @states = State::NAMES.include?(['','']) ? State::NAMES : State::NAMES.insert(0,['',''])
    @countries = {"" => ""}.merge(Country.to_hash_US_first)
    @strategies = Activity.visible_strategies
    @regions = Region.campus_regions
    @title = "Infobase - Advanced Search"
  end

  def last_august
    d = Date.today
    year = d.year
    if d.month <= 8
      year = d.year - 1
    end
    result = Date.parse("#{year}-08-01")
    result
  end

  def _set_current_session
    # Define an accessor. The session is always in the current controller
    # instance in @_request.session. So we need a way to access this in
    # our model
    accessor = instance_variable_get(:@_request)
    ActiveRecord::Base.send(:define_method, "session", proc {accessor.session})
  end
end
