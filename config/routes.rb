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

        resources :products, only: [:index] do
          collection do
            get :all
            put :add_to_view
            put :remove_from_view
          end
        end

        resources :cards, only: [:create, :index, :show] do
          member do
            put :cancel
          end
          collection do
            put :activate
          end
        end
      end
    end
  end

  namespace :admin do
    resources :clients
    resources :products
    resources :brands
    resources :orders
  end
end
