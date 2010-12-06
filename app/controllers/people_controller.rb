class PeopleController < ApplicationController
  before_filter :setup
  
  def index
    roles
    render :action => :roles
  end
  
  def show
    @person = Person.find(params[:id], :include => [:staff, :current_address])
    @title = "Infobase - " + @person.full_name
  end
  
  def roles
    @region = params[:region] || "NC"
    @regions = Region.campus_regions
    @people = Staff.get_roles(@region)
  end
  
  private
    def setup
      @menubar = "ministry"
      @submenu = "people"
      @title = "Infobase - Person Home"
    end
end
