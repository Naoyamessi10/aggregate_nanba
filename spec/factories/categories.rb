FactoryBot.define do
  factory :category do
    title { 'テスト' }
    created_at { '2018-12-12 12:00:00' }
    updated_at { '2018-12-12 12:00:00' }
    user_id { 1 } 
  end
end