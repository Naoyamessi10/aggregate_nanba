require 'rails_helper'

RSpec.describe Api::V1::WorkTimesMinutesController, type: :controller do
  
  let!(:work_times_minutes) do 
    [
      FactoryBot.create(:work_times_minute, minute: 1),
      FactoryBot.create(:work_times_minute, minute: 30),
      FactoryBot.create(:work_times_minute, minute: 55),   
    ]
  end

  describe "GET #index" do
    before do
      get :index
    end
    it '正しい値がセットされている' do
      expect(JSON.parse(response.body).map{|item| item['minute']}).to eq(['1','30','55'])
    end
  end

end
