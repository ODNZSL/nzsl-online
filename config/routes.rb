# frozen_string_literal: true

NzslOnline::Application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :pages, except: [:show] do
      collection do
        post 'reorder'
      end
      resources :page_parts, except: %i[show index] do
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
    resource :settings, except: %i[destroy create new]
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

  resource :vocab_sheet, only: %i[show destroy update] do
    member do
      get :download_pdf
    end

    resources :items, only: %i[create destroy update] do
      collection do
        post 'reorder'
      end
    end
  end

  get '/sitemap.xml' => 'sitemaps#index', defaults: { format: 'xml' }, as: :sitemap
  get '/random_sign' => 'pages#random_sign'
  get '/:slug' => 'pages#show', :as => :page, :slug => /[A-Za-z0-9\-_]+/
end
