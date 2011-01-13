class PeopleController < ApplicationController
  before_filter :setup
  
  def index
    roles
    render :action => :roles
  end
  
  def show
    @person = Person.not_secure.find(params[:id], :include => [:staff, :current_address])
    @title = "Infobase - " + @person.full_name
  end
  
  def roles
    @region = params[:region] || "NC"
    @regions = Region.campus_regions
    @people = Staff.get_roles(@region)
  end
  
  def search
    search_options
  end
  
  def search_results
    if params[:name].blank? && params[:city].blank? && params[:state].blank? && params[:country].blank? && params[:regions].blank? && params[:strategies].blank? && params[:staff].blank?
      redirect_to search_people_path, :notice => "You must fill in at least one search option."
    end
    if !params[:name].blank? && params[:name].size < 3
      redirect_to search_people_path, :notice => "You must fill in at least three letters of the name."
    end

    @people = Person.where(Person.table_name + ".isSecure != 'T' or " + Person.table_name + ".isSecure is null").order(Person.table_name + ".lastName", Person.table_name + ".firstName").includes(:current_address).includes(:staff)
    if !params[:name].blank?
      query = params[:name].strip.split(' ')
      first = query.first
      last = query.last
      if query.size > 1 #search both last AND first names
        @people = @people.where(Person.table_name + ".lastName like ?", "#{last}%")
        @people = @people.where(Person.table_name + ".firstName like ? or " + Person.table_name + ".preferredName like ?", "#{first}%", "#{first}%")
      else #do an OR search
        @people = @people.where(Person.table_name + ".lastName like ? or " + Person.table_name + ".firstName like ? or " + Person.table_name + ".preferredName like ?", "#{last}%", "#{first}%", "#{first}%")
      end        
    end
    if !params[:city].blank?
      @people = @people.where(Address.table_name + ".city like ?", "#{params[:city]}%")
    end
    if !params[:state].blank?
      @people = @people.where(Address.table_name + ".state = ?", params[:state])
    end
    if !params[:country].blank?
      @people = @people.where(Address.table_name + ".country = ?", params[:country])
    end
    if !params[:staff].blank?
      @people = @people.where(Staff.table_name + ".accountNo is not null")
    end
    if !params[:regions].blank?
      @people = @people.where(Person.table_name + ".region IN (?)", params[:regions])
    end
    if !params[:strategies].blank?
      strategies = Activity.translate_strategies_to_PS(params[:strategies])
      @people = @people.where(Person.table_name + ".strategy IN (?)", strategies)
    end
  end
  
  private
    def setup
      @menubar = "ministry"
      @submenu = "people"
      @title = "Infobase - Person Home"
    end
end
