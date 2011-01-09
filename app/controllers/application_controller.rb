require 'authenticated_system'
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter CASClient::Frameworks::Rails::Filter, AuthenticationFilter, :check_user, :except => [:no, :destroy]
  protect_from_forgery
  
  protected
  
  def check_user
    unless @info_user
      if session[:info_user_id]
        @info_user = InfobaseAdminUser.find(session[:info_user_id])
      elsif session[:info_user_type]
        @info_user = Kernel.const_get(session[:info_user_type]).new
      else
        @info_user = InfobaseUser.determine_infobase_user(current_user())
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
    @search_types = {"Location" => search_locations_path, "Person" => search_people_path, "Team" => search_teams_path}
    @states = State::NAMES.insert(0,['',''])
    @countries = {"" => ""}.merge(Country.to_hash_US_first)
    @strategies = Activity.visible_strategies
    @regions = Region.campus_regions
    @title = "Infobase - Advanced Search"
  end
end
