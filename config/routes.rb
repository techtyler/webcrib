Webcrib::Application.routes.draw do

  get "player_stats/summary"
  get "game_stats/summary"
  get "game_stats/add"
  get 'play' => 'active_games#show', :as => 'play'

  get 'log_out' => 'sessions#destroy', :as => 'log_out'
  get 'log_in' => 'sessions#create', :as => 'log_in'
  get 'sign_up' => 'crib_players#new', :as => 'sign_up'

  get 'throw' => 'active_hands#throw', :as => 'throw'

  get 'peg' => 'pegging#peg', :as => 'peg'
  get 'hand' => 'active_hands#hand', :as => 'hand'

  get 'new_game' => 'active_games#new_game', :as => 'new_game'
  get 'new_hand' => 'active_games#new_hand', :as => 'new_hand'


  get 'home' => 'status#show', :as => 'home'

  root :to => 'status#show'


  resources :active_games
  resources :active_hands
  resources :crib_players
  resources :sessions

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
