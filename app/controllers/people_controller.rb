class PeopleController < ApplicationController
  before_filter :setup
  before_filter :authorize_merge, only: [:search_ids, :merge, :confirm_merge, :do_merge, :merge_preview]

  def index
    roles
    render :action => :roles
  end

  def show
    @person = Person.not_secure.find(params[:id], :include => [:staff, :current_address])
    @person.build_current_address unless @person.current_address
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
    if !params[:name].blank? && params[:name].size < 2
      redirect_to search_people_path, :notice => "You must fill in at least two letters of the name."
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
  
  def search_ids
    @people = Ccc::Person.search_by_name(params[:q])

    respond_to do |wants|
      wants.json { render text: @people.collect(&:id).to_json }
    end
  end

  def merge
    @people = 1.upto(4).collect {|i| Ccc::Person.find_by_personID(params["person#{i}"]) if params["person#{i}"].present?}.compact
  end

  def confirm_merge
    @people = 1.upto(4).collect {|i| Ccc::Person.find_by_personID(params["person#{i}"]) if params["person#{i}"].present?}.compact

    unless @people.length >= 2
      redirect_to merge_people_path(params.slice(:person1, :person2, :person3, :person4)), alert: "You must select at least 2 people to merge"
      return false
    end
    @keep = @people.delete_at(params[:keep].to_i)
    unless @keep
      redirect_to merge_people_path(params.slice(:person1, :person2, :person3, :person4)), alert: "You must specify which person to keep"
      return false
    end
    # If any of the other people have users, the keeper has to have a user
    unless @keep.user
      if person = @people.detect(&:user)
        redirect_to merge_people_path(params.slice(:person1, :person2, :person3, :person4)), alert: "Person ID# #{person.id} has a user record, but the person you are trying to keep doesn't. You should keep the record with a user."
        return false
      end
    end

  end

  def merge_preview
    render :nothing => true and return false unless params[:id].to_i > 0
    @person = Ccc::Person.find_by_personID(params[:id])
    respond_to do |wants|
      wants.js {  }
    end
  end

  def do_merge
    @keep = Ccc::Person.find(params[:keep_id])
    params[:merge_ids].each do |id|
      person = Ccc::Person.find(id)
      @keep = @keep.smart_merge(person)
    end
    redirect_to merge_people_path, notice: "You've just merged #{params[:merge_ids].length + 1} people"
  end

  private
  def setup
    @menubar = "ministry"
    @submenu = "people"
    @title = "Infobase - Person Home"
  end

  def authorize_merge
    unless Ccc::SuperAdmin.all.collect(&:user_id).include? current_user.id
      redirect_to "/people"
      flash[:error] = "You are not permitted to access that feature"
    end
  end
end
