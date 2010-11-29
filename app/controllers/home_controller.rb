class HomeController < ApplicationController
  before_filter :setup
  
  private
    def setup
      @menubar = "home"
    end
end
