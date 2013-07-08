DaykoozieCom::Application.routes.draw do


  namespace :api, :format => :json do
    namespace :v1 do


      resources :calendars, except: [:new] do 
                  
        resources :calendar_roles, only: [:index, :create, :destroy]
        resources :calendar_followers, except: [:new, :edit]

        # delete '/calendar_follower_destroy' => 'calendar_followers#destroy'
        # post '/calendar_follower_create' => 'calendar_followers#create'
        # match "delete_calendar_follower", :to => "calendar_followers#destroy", :as => "delete_calendar_follower"

        resources :events, except: [:new, :edit] do
          member do
            get 'attender'
            get 'unattender'
          end
        end
        # member do
        #   get 'followers'
        # end
      end


      resources :user_roles, except: [:new, :edit]

      resources :messages, except: [:new, :edit]
      resources :user_email_settings, :only => [:edit, :update]
      match "my_email_settings", :to => "user_email_settings#edit", :as => "my_email_settings"

      resources :user_notifications, except: [:new, :edit]


      match "user_events", :to => "profiles#user_events", :as => "user_events"

      match '/cal/feed' => 'calendars#feed',
            :as => "/cal/feed",
            :defaults => { :format => 'atom' }

      match '/events/feed' => 'events#feed',
            :as => "/events/feed",
            :defaults => { :format => 'atom' }

      get "relationships/index"
      get "relationships/show"
      resources :relationships, only: [:create, :destroy]
      resources :event_attendees, :only => [:create, :destroy]

      resources :password_resets      

      resources :users, :only => [:create, :index, :show] do 
        member do
          get 'following'
          get 'followers'
        end
      end
      # match "user_events", :to => "profiles#user_events", :as => "user_events"
      get "users/edit"
      put "users/update"
      delete "users/destroy"
      match "update_user_profile" => "users#edit", :as => "update_user_profile"
      match "delete_user_profile" => "users#destroy", :as => "delete_user_profile"
      match "update_user_profile" => "users#update", :as => "update_user_profile"

      match '/auth/:provider/callback' => 'user_authentications#create'
      resources :user_authentications, :only => [:index, :create, :destroy]

      resources :tokens, :only => [:create]
      delete "tokens/destroy"
      match "delete_user_token" => "tokens#destroy", :as => "delete_user_token"


      resources :feeds, except: [:new, :edit]

    end
  end

  match '/feed' => 'api/v1/calendars#feed', :as => :feed, :format => 'atom'
  resources :contacts, :format => :json , only: [:new, :create]

  match "*path", :to => "errors#routing_error"
end
