PanicWebapp::Application.routes.draw do
  devise_for :users

  resources :leaks
  resources :credentials
  match 'about' => 'about#about'
  match 'contact' => 'about#contact'
  root :to => 'about#index'
end
