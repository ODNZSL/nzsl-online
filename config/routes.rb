NzslOnline::Application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :pages, except: [:show] do
      collection do
        post 'reorder'
      end
      resources :page_parts, except: [:show, :index] do
        collection do
          post 'reorder'
        end
      end
    end
    resource :user, only: [:edit] do
      collection do
        patch 'update_password'
      end
    end
    resource :settings, except: [:destroy, :create, :new]
    resources :requests, only: [:index]
  end

  get '/admin', to: redirect('/admin/pages')

  root to: 'pages#show'

  resources :signs, only: :show do
    collection do
      get 'search'
      get 'autocomplete'
    end
  end

  resources :feedback, only: [:create]

  resource :vocab_sheet, only: [:show, :destroy, :update] do
    resources :items, only: [:create, :destroy, :update] do
      collection do
        post 'reorder'
      end
    end
  end

  get 'sign_image/show'
  get '/images/signs/:width-:height/*filename' => 'sign_image#show', :width => /\d+/, :height => /\d+/, :format => false
  get '/assets/signs/:width-:height/*filename' => 'sign_image#show', :width => /\d+/, :height => /\d+/, :format => false

  get '/:slug' => 'pages#show', :as => :page, :slug => /[A-Za-z0-9\-\_]+/
end
