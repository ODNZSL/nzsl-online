NzslOnline::Application.routes.draw do

  root :to => "signs#landing"

  resources :signs, :only => :show do
    collection do
      get 'search'
    end
  end

  resource :vocab_sheet, :only => [:show, :destroy] do
    resources :items, :only => [:create, :destroy]
  end
end

