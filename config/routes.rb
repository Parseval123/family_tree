Rails.application.routes.draw do
  
  devise_scope :admin do
    get "/sign_in" => "devise/sessions#new" # custom path to login/sign_in
    get "/sign_up" => "devise/registrations#new", as: "new_admin_registration" # custom path to sign_up/registration
  end
  
  devise_for :admins, :skip => [:registrations]
	  
  resources :posts
  root to: "static_pages#home"
  #root to: "posts#index"
  get 'static_pages/contacts'
  get 'static_pages/projects'
  get 'static_pages/shop'
  get 'static_pages/draw_tree_submit'
  get 'static_pages/manage_over_hit'
  post 'static_pages/draw_tree_render'
  get 'static_pages/draw_tree_render' => 'static_pages/draw_tree_submit'
  # routes for elders 
  get 'static_pages/vincenzo_tomassi'
  
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
