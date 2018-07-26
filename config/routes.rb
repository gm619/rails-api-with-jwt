Rails.application.routes.draw do
  resources :users, only: %i[create] do
    collection do
      get 'show'
      put 'edit'
      post 'sign_in'
    end
  end
end
