DaykoozieCom::Application.routes.draw do


  namespace :api, :format => :json do
    namespace :v1 do

      resources :event_attendees, except: [:new, :edit]

      resources :messages, except: [:new, :edit]

      resources :user_email_settings, except: [:new, :edit]

      resources :user_notifications, except: [:new, :edit]

      resources :relationships, except: [:new, :edit]

      resources :calendar_roles, except: [:new, :edit]

      resources :calendar_followers, except: [:new, :edit]

      resources :feeds, except: [:new, :edit]

      resources :user_authentications, except: [:new, :edit]

      resources :events, except: [:new, :edit]

      resources :contacts, except: [:new, :edit]

      resources :calendars, except: [:new, :edit]


      resources :user_roles, except: [:new, :edit]


      get "calendar_roles/create"

      get "calendar_roles/destroy"

      resources :messages
      resources :user_email_settings, :only => [:edit, :update]
      match "my_email_settings", :to => "user_email_settings#edit", :as => "my_email_settings"

      resources :user_notifications

      get "relationships/index"
      get "relationships/show"

      get "test/welcome"
      get "test/new_event"
      get "test/contact"
      get "test/index"

      resources :categories

      resources :calendar_roles, only: [:create, :destroy]

      # delete '/calendar_follower_destroy' => 'calendar_followers#destroy'
      # post '/calendar_follower_create' => 'calendar_followers#create'

      # match "delete_calendar_follower", :to => "calendar_followers#destroy", :as => "delete_calendar_follower"


      resources :calendars do
        # member do
        #   get 'followers'
        # end
        resources :events do 
          member do
            get 'attender'
            get 'unattender'
          end

        end
      end

      get '/explore' => 'calendars#index', :calendar_nav => "active"

      get '/koozie' => 'home#koozie', :koozie_nav => "active"

      match "user_events", :to => "profiles#user_events", :as => "user_events"

      # match "/the_calendar/:id", :to => "contacts#new", :as => "contact"


      match '/cal/feed' => 'calendars#feed',
            :as => "/cal/feed",
            :defaults => { :format => 'atom' }

      match '/events/feed' => 'events#feed',
            :as => "/events/feed",
            :defaults => { :format => 'atom' }

      get "home/about"
      match "about", :to => "home#about", :as => "about"
      get "home/help"
      match "help", :to => "home#help", :as => "help"

      resources :contacts
      match "contact", :to => "contacts#new", :as => "contact"

      resources :relationships, only: [:create, :destroy]
      resources :event_attendees, :only => [:create, :destroy]

      resources :password_resets      

      resources :users, :only => [:create, :index, :show] do 
        member do
          get 'following'
          get 'followers'
        end
      end
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

      match "user_events", :to => "profiles#user_events", :as => "user_events"

    end
  end

  match '/feed' => 'api/v1/calendars#feed', :as => :feed, :format => 'atom'

  resources :contacts, :format => :json , only: [:new, :create]

  # root :to => 'welcome#index'

  match "*path", :to => "errors#routing_error"
end
