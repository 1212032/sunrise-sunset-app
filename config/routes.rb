Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :sun_events, only: [:index]
    end
  end

  get '*path', to:'pages#index', via: :all
end
