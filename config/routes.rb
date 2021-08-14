Rails.application.routes.draw do
  
  root to: "static_pages#home"
  get 'static_pages/contacts'
  get 'static_pages/projects'
  get 'static_pages/shop'
  devise_for :admins
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
