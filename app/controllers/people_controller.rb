class PeopleController < ApplicationController
  before_filter :setup
  
  def show
    @person = Person.find(params[:id], :include => [:staff, :current_address])
    @title = "Infobase - " + @person.full_name
  end
  
  private
    def setup
      @menubar = "ministry"
    end
end
