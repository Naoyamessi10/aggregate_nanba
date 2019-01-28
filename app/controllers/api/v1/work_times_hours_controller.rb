module Api::V1
  class WorkTimesHoursController < ApplicationController

    def index
      @work_times_hours = WorkTimesHour.all
      render json: @work_times_hours
    end

  end
end