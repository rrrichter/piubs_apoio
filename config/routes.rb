Rails.application.routes.draw do
  resources :calls
  resources :answers
  namespace :admin do
      resources :users
      root to: "users#index"
    end
  root to: 'visitors#index'
  devise_for :users
  resources :users
  get '/call/show_atendimento/:id', to: "calls#show_atendimento", as: 'call_show_atendimento'
  get '/call/search', to: "calls#search", as: 'call_search'
  get '/call/associate/:answer_id/:call_id', to: "calls#associate", as: 'call_associate_answer'
end
