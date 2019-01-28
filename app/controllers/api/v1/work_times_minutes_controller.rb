module Api::V1
  class WorkTimesMinutesController < ApplicationController

    def index
      @work_times_minutes = WorkTimesMinute.all
      render json: @work_times_minutes
    end

  end
end