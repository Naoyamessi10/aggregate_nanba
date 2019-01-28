Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :work_times, format: 'json' do
        collection do
          post :import, :create_cookie
        end
      end
      resources :categories, only: [:show, :create], format: 'json'
      resources :show_graph, only: [:index], format: 'json'
      resources :work_times_hours, only: [:index], format: 'json'
      resources :work_times_minutes, only: [:index], format: 'json'
      resources :work_users_lists, only: [:index], format: 'json'
    end
  end 
end
