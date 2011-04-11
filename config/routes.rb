NzslOnline::Application.routes.draw do
  root :to => "signs#landing"

  resources :signs, :only => :show do
    collection do
      get 'search'
    end
  end

  resource :vocab_sheet, :only => [:show, :destroy] do
    resources :items, :only => [:create, :destroy, :update] do
      collection do
        post 'reorder'
      end
    end
  end

  get "/s/:slug" => 'static_pages#show', :as => :page, :slug => /[A-Za-z0-9\-\_]+/
end

