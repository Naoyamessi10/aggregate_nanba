module Api::V1
  class WorkTimesController < ApplicationController
    SEARCH_WORD1 = '#作業能動'.freeze
    SEARCH_WORD2 = '#作業受動'.freeze
    SEARCH_WORD3 = '#休憩'.freeze
    SEARCH_WORD4 = '#外出'.freeze
    SEARCH_WORD5 = '#その他'.freeze
    UNSEARCH_WORD = '#対象外'.freeze
    FIRST_CATEGORY = '会議'.freeze

    def index
      sum_times = aggregate_time(params[:user_id])
      work_times = {}
      sum_times.each do |sum_time|
        work_times[sum_time[0]] = (sum_time[1].to_f).round(1)
      end
      render json: work_times.blank? ? { message: I18n.t('record_not_found'), status: 404 } : work_times
    end

    def create
      work_time = WorkTime.new(time: hour_add_minute, category_id: params[:category_id], created_at: created_at,
                              user_id: params[:user_id])
      work_time.save!
      render json: { message: I18n.t('create_work_time_message'), status: 200 }
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.record.errors.full_messages, status: 400 }
    end

    def create_cookie
      calendars_service = GoogleApi::CalendarsService.new
      new_id = calendars_service.create_new_id(params)
      render json: { message: I18n.t('create_user_id'), status: 200, user_id: new_id}
    end

    def import
      Slack.chat_postMessage(text: 'ログインがありました', username: 'slack_test', channel: "@naoyamessi10")
      calendars_service = GoogleApi::CalendarsService.new

      access_token = calendars_service.refresh_token(params[:user_id])
      calendar_datas = calendars_service.calendar_api_refresh_token(access_token)
      category_id = check_category_id
      work_times = divide_calendar_datas(calendar_datas, category_id)
      WorkTime.import work_times
      render json: { message: I18n.t('seach_google_calendar'), status: 200 , cookie: params[:user_id]}
    rescue => e
      render json: { message: e, status: 500}
    end

    private

    def divide_calendar_datas(calendar_datas, category_id)
      work_times = []

      WorkTime.where(user_id: params[:user_id]).delete_all
      calendar_datas.each do |calendar_data|
        # カレンダーのデータに終日と本文がない場合はスキップ
        next if !(calendar_data.start.date.nil?)
        if calendar_data.description.nil?
          work_times << WorkTime.new(time: calc_work_time(calendar_data.start.dateTime, calendar_data.end.dateTime),
                                     category_id: category_id, created_at: calendar_data.start.dateTime, updated_at: calendar_data.end.dateTime,
                                     user_id: params[:user_id])
          # カテゴリ名が含まれているか判定
        elsif (calendar_data.description.include?(SEARCH_WORD1) == false && calendar_data.description.include?(SEARCH_WORD2) == false  && calendar_data.description.include?(SEARCH_WORD3) == false  && calendar_data.description.include?(SEARCH_WORD4) == false  && calendar_data.description.include?(SEARCH_WORD5) == false)
          next if calendar_data.description.include?(UNSEARCH_WORD)
          work_times << WorkTime.new(time: calc_work_time(calendar_data.start.dateTime, calendar_data.end.dateTime),
                                    category_id: category_id, created_at: calendar_data.start.dateTime, updated_at: calendar_data.end.dateTime,
                                    user_id: params[:user_id])
        else
          # カテゴリ名が含まれていた場合の処理
          next if calendar_data.description.include?(UNSEARCH_WORD)
          create_category_id = search_category_id(calendar_data.description)
          work_times << WorkTime.new(time: calc_work_time(calendar_data.start.dateTime, calendar_data.end.dateTime),
                                    category_id: create_category_id, created_at: calendar_data.start.dateTime, updated_at: calendar_data.end.dateTime,
                                    user_id: params[:user_id])
        end
      end
      work_times
    end

    def search_category_id(content)
      return 2 if content.include?(SEARCH_WORD1)
      return 3 if content.include?(SEARCH_WORD2)
      return 4 if content.include?(SEARCH_WORD3)
      return 5 if content.include?(SEARCH_WORD4)
      return 6 if content.include?(SEARCH_WORD5)
    end

    def check_category_id
      Category.search_id(1, FIRST_CATEGORY)[0]
    end

    # 業務時間を集計し、返す
    def aggregate_time(user_id)
      work_times = params[:type_flag] == 'false' ? calctime(user_id) : calctime_category(user_id)
    end

    # 月、日別に業務時間を計算
    def calctime(user_id)
      work_times = params[:day].include?('to') ? WorkTime.aggregate_by_range(user_id, params[:day].slice(0..9), params[:day].slice(14..23)) : WorkTime.aggregate_by_title(user_id, params[:day])
    end

    # カテゴリごとに月、日別で業務時間を計算
    def calctime_category(user_id)
      work_times = params[:day].include?('to') ? WorkTime.aggregate_range_category(user_id, params[:category_id], params[:day].slice(0..9), params[:day].slice(14..23)) : WorkTime.aggregate_by_category(user_id, params[:category_id], params[:day])
    end

    # 時間と分を足す
    def hour_add_minute
      hour = params[:hour].to_i
      minute = (params[:minute].to_i / 60.to_f).round(1)
      hour == 0 && minute == 0 ? '' : hour + minute
    end

    def created_at
      d = Date.today
      "#{d.year}-#{params[:month]}-#{params[:day]}"
    end

    # 秒単位を時間単位に変換
    def calc_work_time(startTime, endTime)
      startTime == 0 || endTime == 0 ? '' : ((endTime - startTime)/60/60).round(1)
    end

    def work_time_params
      params.require(:work_time).permit(:category_id)
    end

  end
end
