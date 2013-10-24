require 'spec_helper'

describe Api::V1::StatisticsController do
  let(:api_key) { create(:api_key) }
  let!(:activity) { create(:activity) }

  before do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  context '#activity' do
    it 'returns http success' do
      get 'activity', access_token: api_key.access_token, begin_date: '2013-01-01', end_date: '2013-01-08', activity_id: activity.id
      response.should be_success
    end
  end

  context '#create' do
    it 'inserts stats' do
      statistics = [
                     {activity_id: activity.id,
                      period_begin: '2013-01-01',
                      period_end: '2013-01-08',
                      students_involved: 5
                     }
                   ]
      expect {
        post :create, statistics: statistics, access_token: api_key.access_token
      }.to change(Statistic, :count).by(1)
    end

    it 'updates stats' do
      s = Statistic.create!(activity: activity, period_begin: '2012-12-30', period_end: '2013-01-08', students_involved: 1)
      statistics = [
        {id: s.id,
         activity_id: activity.id,
         period_begin: s.period_begin,
         period_end: s.period_end,
         students_involved: 5
        }
      ]
      post :create, statistics: statistics, access_token: api_key.access_token

      s.reload.students_involved.should == 5
    end
  end

end
