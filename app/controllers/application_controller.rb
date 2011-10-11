require 'authenticated_system'
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter CASClient::Frameworks::Rails3::Filter, AuthenticationFilter, :check_user, :current_user, :except => [:no, :destroy]
  protect_from_forgery
  
  def self.application_name
    "Infobase"
  end
  
  protected
  
  def check_user
    unless @info_user
      if session[:info_user_id]
        @info_user = InfobaseAdminUser.find(session[:info_user_id])
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
    end
    @current_user
  end
  
  def search_options
    @search_types = {"Location" => "locations", "Person" => "people", "Team" => "teams"}
    @states = State::NAMES.insert(0,['',''])
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
end
