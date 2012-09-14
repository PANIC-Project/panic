PanicWebapp::Application.routes.draw do
  # Set up devise, but skip registration routes
  #devise_for :users
  devise_for :users, :skip => [:registrations]
  # Add in registration edit routes, leaving off new user sign up
  as :user do
    get '/users' => 'devise/registrations#create', :as => 'registration'
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  resources :leaks
  resources :credentials
  match 'about' => 'about#about'
  match 'contact' => 'about#contact'
  root :to => 'about#index'
end
