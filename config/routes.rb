ApplicationDeploymentManager::Application.routes.draw do

  resources :devices do
    collection do
      get :show_upload
      post :upload
    end
  end

  resources :applications do
    resources :versions, :has_many => :version_configurations
  end

  devise_for :users

  root :to => "home#index"
end
