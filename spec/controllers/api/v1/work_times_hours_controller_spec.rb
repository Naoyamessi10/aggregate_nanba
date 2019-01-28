require 'rails_helper'

RSpec.describe Api::V1::WorkTimesHoursController, type: :controller do
  
  let!(:work_times_hours) do 
    [
      FactoryBot.create(:work_times_hour, hour: 0),
      FactoryBot.create(:work_times_hour, hour: 1),
      FactoryBot.create(:work_times_hour, hour: 2),   
    ]
  end

  describe "GET #index" do
    before do
      get :index
    end
    it '必要な値がセットされている' do
      expect(JSON.parse(response.body).map{|item| item['hour']}).to eq(['0','1','2'])
    end
  end

end
