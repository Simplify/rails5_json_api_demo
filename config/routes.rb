Rails.application.routes.draw do
  resources :users
  resources :posts

  post    'sessions'     => 'sessions#create'
  delete  'sessions/:id' => 'sessions#destroy'
end
