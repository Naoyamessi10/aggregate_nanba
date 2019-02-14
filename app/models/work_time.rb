class WorkTime < ApplicationRecord
  belongs_to :category, optional: true
  validates :time, presence: true

  scope :of_search, ->(user_id, date) { joins(:category).where("work_times.user_id = ? and work_times.created_at LIKE ?", "#{user_id}", "#{date}%")}
  scope :of_range, ->(user_id, day1, day2) { joins(:category).where("work_times.user_id = ? and work_times.created_at between ? and ?", "#{user_id}", "#{day1} 00:00:00", "#{day2} 23:59:59") }
  scope :search_same_data, ->(time, created_at, user_id) { where(time: time, created_at: created_at, user_id: user_id) }

  class << self
    def aggregate_by_title(user_id, date)
      of_search(user_id, date).group(:title).sum(:time)
    end

    def aggregate_by_range(user_id, day1, day2)
      of_range(user_id, day1, day2).group(:title).sum(:time)
    end

    def aggregate_by_category(user_id, category_id, date)
      of_search(user_id, date).where(category_id: category_id).group(:title).sum(:time)
    end

    def aggregate_range_category(user_id, category_id, day1, day2)
      of_range(user_id, day1, day2).where(category_id: category_id).group(:title).sum(:time)
    end

  end

end
