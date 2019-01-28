FactoryBot.define do
  factory :work_time do
    time { 1.1 }
    category_id { 1 }
    created_at { '2019-12-12 12:00:00' }
    updated_at { '2019-12-12 12:00:00' }
    user_id { 1111 }
  end
end
