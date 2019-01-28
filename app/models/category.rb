class Category < ApplicationRecord
  belongs_to :work_time, optional: true
  validates :title, presence: true
  accepts_nested_attributes_for :work_time

  scope :search_category, ->(user_id) { where("user_id = ?", "#{user_id}")}
  scope :search_title, ->(title, user_id) { where(title: title, user_id: user_id)}

  class << self
    def search_id(title, user_id)
      search_title(title, user_id).pluck(:id)
    end
  end

end