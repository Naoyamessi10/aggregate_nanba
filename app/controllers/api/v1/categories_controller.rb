module Api::V1
  class CategoriesController < ApplicationController
    before_action :create_first_category, only: :show

    FIRST_CATEGORY = '会議'.freeze

    def show
      @categories = Category.search_category(params[:id])
      render json: @categories
    end

    def create
      unless Category.search_title(params[:title], params[:user_id]).blank?
        render json: { message: I18n.t('category_exist'), status: 400 }
        return
      end
      category = Category.new(title: params[:title], user_id: params[:user_id])
      category.save!
      render json: { message: I18n.t('create_category_message'), status: 200 }
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.record.errors.full_messages, status: 400 }
    end

    private

    def create_first_category
      #カテゴリがなかったら作る
      if Category.search_category(params[:id]).blank?
        category = Category.new(title: FIRST_CATEGORY, user_id: params[:id])
        category.save!
      end
    end

  end
end
