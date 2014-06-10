require 'spec_helper'

describe HomeController do
  let(:person) { create(:person) }
  let(:user) { create(:user, person: person) }
  let!(:infobase_user) { create(:infobase_user, user: user) }

  before do
    session[:cas_user] = 'foo@example.com'
    session[:user_id] = user.id
  end

  context '#index' do
    it 'responds with a 200' do
      get :index

      expect(response.status).to eq(200)
    end

  end

  context '#search' do
    it 'redirects to person search' do
      post :search, type: 'people', search: {}
      expect(response).to redirect_to(search_results_people_path)
    end

    it 'redirects to location search' do

    end

    it 'redirects to teams search' do

    end

    it 'defaults to redirecting back to home' do

    end
    # case type
    # when "people"
    #   params[:search][:name] = params[:search][:namecity] if params[:search][:namecity]
    #   redirect_to search_results_people_path(params[:search])
    # when "locations"
    #   redirect_to search_results_locations_path(params[:search])
    # when "teams"
    #   redirect_to search_results_teams_path(params[:search])
    # else
    #   redirect_to :home
    # end
  end
end
