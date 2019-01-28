class WorkUsersList < ApplicationRecord
  validates :user_name, presence: true
end