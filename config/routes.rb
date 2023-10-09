Rails.application.routes.draw do
  devise_for :admins, controllers: {
    registrations: 'admin/registrations',
    sessions: 'admin/sessions',
    passwords: 'admin/passwords',
    confirmations: 'admin/confirmations',
  }
  root to: 'admin/brands#index'

  # namespace :api do
  #   namespace :v1 do
  #   end
  # end

  namespace :admin do
    resources :clients
    resources :products
    resources :brands
  end
end
