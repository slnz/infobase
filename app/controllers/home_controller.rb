class HomeController < ApplicationController
  before_filter :setup
  
  def search
    redirect_to search_people_path
  end
  
  private
    def setup
      @menubar = "home"
    end
end
