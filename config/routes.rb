Rails.application.routes.draw do
  scope path: '/api' do
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    resources :movies do
      collection do
        get 'search'
        get 'import'
      end
    end
  end
end
