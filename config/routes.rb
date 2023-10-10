Rails.application.routes.draw do
  root to: 'admin/brands#index'

  devise_for :admins, controllers: {
    registrations: 'admin/registrations',
    sessions: 'admin/sessions',
    passwords: 'admin/passwords',
    confirmations: 'admin/confirmations',
  }

  namespace :api do
    namespace :client do
      namespace :v1 do
        get '/' => 'document#index'
        resources :accounts, only: [] do
          collection do
            get :profile
            post :login
            delete :logout
            put :update
          end
        end
      end
    end
  end

  namespace :admin do
    resources :clients
    resources :products
    resources :brands
  end
end
