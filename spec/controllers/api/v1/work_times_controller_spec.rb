require 'rails_helper'
require 'google/api_client'

RSpec.describe Api::V1::WorkTimesController, type: :controller do
  
  let!(:work_times) do 
    [
      FactoryBot.create(:work_time, time: '1.5', category_id: 1),
      FactoryBot.create(:work_time, time: '2.0', category_id: 1),
      FactoryBot.create(:work_time, time: '2.0', category_id: 1, created_at: '2019-12-13 12:00:00'),
      FactoryBot.create(:work_time, time: '3.0', category_id: 2),
      FactoryBot.create(:work_time, time: '1.0', category_id: 2),
      FactoryBot.create(:work_time, time: '1.0', category_id: 2, created_at: '2019-12-13 12:00:00'),
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

  describe "GET #index" do
    describe '日別の集計' do
      context '集計できた場合' do
        it 'responseが正しいか' do
          get :index, params: {type_flag: 'false', month: 12, day: 12, user_id: 1111}
          expect((JSON.parse(response.body))['会議']).to eq('3.5')
          expect((JSON.parse(response.body))['資料作成']).to eq('4.0')
          expect((JSON.parse(response.body))['開発']).to eq('2.5')
        end
      end

      context '集計した結果何もデータがない場合' do
        it 'エラーが返ってくる' do
          get :index, params: {type_flag: 'false', month: 13, day: 32, user_id: 1111}
          expect(JSON.parse(response.body)['message']).to eq('データが見つかりませんでした')
          expect(JSON.parse(response.body)['status']).to eq(404)
        end
      end
    end

    describe '月別の集計' do
      context '集計できた場合' do
        it 'responseが正しいか' do
          get :index, params: {type_flag: 'false', month: 12, user_id: 1111}
          expect((JSON.parse(response.body))['会議']).to eq('5.5')
          expect((JSON.parse(response.body))['資料作成']).to eq('5.0')
          expect((JSON.parse(response.body))['開発']).to eq('2.5')
        end
      end

      context '集計した結果何もデータがない場合' do
        it 'エラーが返ってくる' do
          get :index, params: {type_flag: 'false', month: 13, user_id: 1111}
          expect(JSON.parse(response.body)['message']).to eq('データが見つかりませんでした')
          expect(JSON.parse(response.body)['status']).to eq(404)
        end
      end
    end

    describe 'カテゴリごと日別の集計' do
      context '集計できた場合' do
        it 'responseが正しいか' do
          get :index, params: {type_flag: 'true', month: 12, day: 12, category_id: 1, user_id: 1111}
          expect((JSON.parse(response.body))['会議']).to eq('3.5')
        end
      end

      context '集計した結果何もデータがない場合' do
        it 'エラーが返ってくる' do
          get :index, params: {type_flag: 'true', month: 13, day: 31, user_id: 1111}
          expect(JSON.parse(response.body)['message']).to eq('データが見つかりませんでした')
          expect(JSON.parse(response.body)['status']).to eq(404)
        end
      end
    end

    describe 'カテゴリごと月別の集計' do
      context '集計できた場合' do
        it 'responseが正しいか' do
          get :index, params: {type_flag: 'true', month: 12, category_id: 2, user_id: 1111}
          expect((JSON.parse(response.body))['資料作成']).to eq('5.0')
        end
      end

      context '集計した結果何もデータがない場合' do
        it 'エラーが返ってくる' do
          get :index, params: {type_flag: 'true', month: 13, day: 31, user_id: 1111}
          expect(JSON.parse(response.body)['message']).to eq('データが見つかりませんでした')
          expect(JSON.parse(response.body)['status']).to eq(404)
        end
      end
    end
  end

  describe "POST #create" do
    context 'リクエストが正しい場合' do
      before do
        post :create, params: {hour: '10', minute: '40', category_id: '10', user_id: 1111}
      end
      it 'responseが正しいか' do
        expect(JSON.parse(response.body)['message']).to eq('業務時間を保存しました。')
        expect(JSON.parse(response.body)['status']).to eq(200)
      end
    end

    context 'リクエストが正しくない場合' do
      before do
        post :create, params: {hour: 0, minute: 0, category_id: '11', user_id: 1111}
      end
      it 'エラーが返ってきている' do
        expect(JSON.parse(response.body)['message']).to eq(["Time translation missing: ja.activerecord.errors.models.work_time.attributes.time.blank"])
        expect(JSON.parse(response.body)['status']).to eq(400)
      end
    end
  end

  describe "POST #import" do
    before do
      allow_any_instance_of(GoogleApi::CalendarsService).to receive(:refresh_token) { 'test' }
      allow(controller).to receive(:test) { [time: 1.0, category_id: 34, created_at: DateTime.parse("2019-12-17 12:00:00"), updated_at: DateTime.parse("2019-12-17 13:00:00"), user_id: 1111] }
      post :import
    end
    it 'responseが正しいか' do
      expect(JSON.parse(response.body)['message']).to eq('googleカレンダーから取得しました！')
      expect(JSON.parse(response.body)['status']).to eq(200)
    end
  end

end
