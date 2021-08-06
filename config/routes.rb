Rails.application.routes.draw do
  
  devise_for :admins
  root to: "static_pages#home"
  #get 'static_pages/home'
  get 'static_pages/help'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
