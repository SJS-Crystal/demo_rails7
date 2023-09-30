Rails.application.routes.draw do
  root to: 'admin/brands#index'

  # namespace :api do
  #   namespace :v1 do
  #   end
  # end

  namespace :admin do
    resources :brands
  end
end
