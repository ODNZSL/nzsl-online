NzslOnline::Application.routes.draw do
  get "sign_image/show"

  root :to => "static_pages#show"

  resources :signs, :only => :show do
    collection do
      get 'search'
    end
  end
  
  resources :feedback, :only => [:new, :create]
  get '/feedback' => 'feedback#new'

  resource :vocab_sheet, :only => [:show, :destroy] do
    resources :items, :only => [:create, :destroy, :update] do
      collection do
        post 'reorder'
      end
    end
  end

  get "/images/signs/:width-:height/*filename" => "sign_image#show", :width => /\d+/, :height => /\d+/
  get "/:slug" => 'static_pages#show', :as => :page, :slug => /[A-Za-z0-9\-\_]+/
end

