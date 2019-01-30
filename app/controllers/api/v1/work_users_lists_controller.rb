module Api::V1
  class WorkUsersListsController < ApplicationController

    def index
      users = Hash.new { |h, k| h[k] = [] }
      user_id = cookies[:user_id]
      work_times = params[:type_flag] == 'false' ? calctime(user_id) : calctime_category(user_id)

      #集計した時間とusersを紐付けて返す
      work_times.each do |work_time|
        next if WorkUsersList.where(work_time_id: work_time[:id]).blank?
        title = Category.find(work_time[:category_id]).title
        users_lists = WorkUsersList.where(work_time_id: work_time[:id])
        users_lists.each do |users_list|
          users[title].push(users_list[:user_name])
        end
      end
      render json: users
    end

    # 月、日別に業務時間を集計
    def calctime(user_id)
      work_times = params[:day].nil? ? WorkTime.of_search(user_id, change_time(params[:month])) : WorkTime.of_search(user_id, "#{change_time(params[:month])}-#{change_time(params[:day])}")
    end

    #　カテゴリごとに月、日別に業務時間を集計
    def calctime_category(user_id)
      work_times = params[:day].nil? ? WorkTime.of_search(user_id, change_time(params[:month])).where(category_id: params[:category_id]) : WorkTime.of_search(user_id, "#{change_time(params[:month])}-#{change_time(params[:day])}").where(category_id: params[:category_id])
    end

    def change_time(times)
      return times unless times.to_i <= 9
      "0#{times}"
    end

  end
end