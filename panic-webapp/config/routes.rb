PanicWebapp::Application.routes.draw do
  resources :leaks
  resources :credentials
  root :to => 'about#index'
end
