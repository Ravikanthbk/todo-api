Rails.application.routes.draw do
  # scope '/api/v1' do
  #   resources :tasks
  # end

  namespace :api do
    namespace :v1 do
      resources :tasks
    end
  end

  # scope '/api/v1' do
    # resources :tags
  # end

  namespace :api do
    namespace :v1 do
      resources :tags
    end
  end  
  # get 'tags/index'
  # get 'tags/create'
  # get 'tags/update'
  # get 'tags/destroy'
  # get 'tasks/index'
  # get 'tasks/create'
  # get 'tasks/update'
  # get 'tasks/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  match '*unmatched', to: 'application#route_not_found', via: :all
  
end
