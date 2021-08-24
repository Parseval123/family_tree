Rails.application.routes.draw do
  
  resources :posts
  root to: "static_pages#home"
  #root to: "posts#index"
  get 'static_pages/contacts'
  get 'static_pages/projects'
  get 'static_pages/shop'
  get 'static_pages/draw_tree_submit'
  post 'static_pages/draw_tree_render'
  get 'static_pages/draw_tree_render' => 'static_pages/draw_tree_submit'
  # routes for elders 
  get 'static_pages/vincenzo_tomassi'
  
  devise_for :admins
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
