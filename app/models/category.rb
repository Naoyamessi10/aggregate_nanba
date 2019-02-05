class Category < ApplicationRecord
  belongs_to :work_time, optional: true
  validates :title, presence: true
  accepts_nested_attributes_for :work_time

  scope :search_category, ->(user_id) { where("user_id = ?", "#{user_id}")}
  scope :search_title, ->(id, title) { where(id: id, title: title)}

  class << self
    def search_id(id, title)
      search_title(id, title).pluck(:id)
    end
  end

end
