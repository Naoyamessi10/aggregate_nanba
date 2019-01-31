class WorkTime < ApplicationRecord
  belongs_to :category, optional: true
  validates :time, presence: true

  scope :of_search, ->(user_id, date) { joins(:category).where("work_times.user_id = ? and work_times.created_at LIKE ?", "#{user_id}", "2019-#{date}%")}
  scope :of_week, ->(year, month, day, user_id, today) { joins(:category).where("work_times.user_id = ? and work_times.created_at between ? and ?", "#{user_id}", "#{year}-#{month}-#{day} 00:00:00", "#{today} 23:59:59") }
  scope :search_same_data, ->(time, created_at, user_id) { where(time: time, created_at: created_at, user_id: user_id) }
  
  class << self
    def aggregate_by_title(user_id, date)
      of_search(user_id, date).group(:title).sum(:time)
    end

    def aggregate_by_category(user_id, category_id, date)
      of_search(user_id, date).where(category_id: category_id).group(:title).sum(:time)
    end

    def aggregate_by_title_week(year, month, day, user_id, today)
      of_week(year, month, day, user_id, today).group(:title).sum(:time)
    end

    def aggregate_by_category_week(year, month, day, user_id, today, category_id)
      of_week(year, month, day, user_id, today).where(category_id: category_id).group(:title).sum(:time)
    end
  end

end
