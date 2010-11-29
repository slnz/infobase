class PeopleController < ApplicationController
  def show
    @person = Person.find(params[:id], :include => [:staff, :current_address])
    @title = "Infobase - " + @person.full_name
  end
end
