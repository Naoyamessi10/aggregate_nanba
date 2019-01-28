require 'rails_helper'

RSpec.describe WorkTime, type: :model do

  let!(:work_times) do 
    [
      FactoryBot.create(:work_time, time: '1.5', category_id: 1),
      FactoryBot.create(:work_time, time: '2.0', category_id: 1),
      FactoryBot.create(:work_time, time: '2.0', category_id: 1, created_at: '2018-12-13 12:00:00'),
      FactoryBot.create(:work_time, time: '3.0', category_id: 2),
      FactoryBot.create(:work_time, time: '1.0', category_id: 2),
      FactoryBot.create(:work_time, time: '1.0', category_id: 2, created_at: '2018-12-13 12:00:00'),
      FactoryBot.create(:work_time, time: '2.5', category_id: 3)
    ]
  end

  let!(:categories) do
    [
      FactoryBot.create(:category, id: 1, title: '会議'),
      FactoryBot.create(:category, id: 2, title: '資料作成'),
      FactoryBot.create(:category, id: 3, title: '開発')
    ]
  end

  describe 'aggregate_by_title' do
    context 'リクエストが正しい場合' do
      it 'reponseが正しい' do
        work_times = WorkTime.aggregate_by_title(1111, '12-12')
        expect(JSON.parse(work_times['会議'])).to eq(3.5)
        expect(JSON.parse(work_times['資料作成'])).to eq(4.0)
        expect(JSON.parse(work_times['開発'])).to eq(2.5)
      end
    end

    context 'リクエストが正しくない場合' do
      it '{}が返る' do
        work_times = WorkTime.aggregate_by_title(111, '13-31')
        expect(work_times).to eq({})
      end
    end
  end

  describe 'aggregate_by_category' do
    context 'リクエストが正しい場合' do
      it 'responseが正しい' do
        work_times = WorkTime.aggregate_by_category(1111,1,'12-12')
        expect(JSON.parse(work_times['会議'])).to eq(3.5)
      end
    end

    context 'リクエストが正しくない場合' do
      it '{}が返る' do
        work_times = WorkTime.aggregate_by_category(111, 4, '13-31')
        expect(work_times).to eq({})
      end
    end
  end
end
