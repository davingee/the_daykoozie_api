class Api::V1::UserAuthenticationsController < ApplicationController

  before_filter :require_current_user!, :only => [:index, :destroy]
  before_filter :require_basic_authentication!, :only => [:create]

  def index
    authorize! :manage, current_user, :message => m("user", "unauthorized")
    user_authentications = current_user.user_authentications
    options = { :type => :success, 
                :root => :user_authentications, 
                :status => :ok }
    render_json(user_authentications, options)
  end
  
  def create
    omniauth = env["omniauth.auth"]
    # puts omniauth.inspect
    authentication = UserAuthentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication && authentication.user.present?
      user = authentication.user

      user.move_visitor_info_to_user(params[:visitor_id]) if params[:visitor_id]

      user.ensure_authentication_token!

      options = { :type => :success, 
                  :root => :user, 
                  :status => :ok,
                  :message => m("user_authentication.#{omniauth['provider']}", "login") }
      render_json(user, options)
    elsif current_user
      current_user.user_authentications.find_or_create_by_provider_and_uid(omniauth['provider'], omniauth['uid'])

      options = { :type => :success, 
                  :root => :user, 
                  :status => :ok,
                  :message => m("user_authentication.#{omniauth['provider']}", "update") }
      render_json(current_user, options)

    elsif User.find_by_email(omniauth["info"]["email"])

      options = { :type => :error, 
                  :root => :false, 
                  :status => :not_acceptable,
                  :message => m("user_authentication.#{omniauth['provider']}", "authenticate_first") }
      render_json(current_user, options)

    else
      user = User.new
      user.password_digest = SecureRandom.urlsafe_base64
      if user.apply_omniauth(omniauth)
        if user.save 
          # params[:visitor_id] = 1
          if params[:visitor_id]
            user.move_visitor_info_to_user(params[:visitor_id])
          end

          user.ensure_authentication_token!
          options = { :type => :success, 
                      :root => :user, 
                      :status => :ok,
                      :message => m("user_authentication.#{omniauth['provider']}", "create") }
          render_json(user, options)
        else
          user.provider = omniauth['provider']
          user.uid = omniauth['uid']
          options = { :type => :error, 
                      :root => :user, 
                      :status => :conflict,
                      :message => user.errors.as_json }
          render_json(user, options)
        end
      else

        options = { :type => :error, 
                    :root => :false, 
                    :status => :unprocessable_entity,
                    :message => m("user_authentication", "fail") }
        render_json(nil, options)
      end
    end

  end
  
  # alias_method :facebook, :create
  # alias_method :google_oauth2, :create
  
  def destroy
    authorize! :manage, current_user, :message => m("user", "unauthorized")
    user_authentication = current_user.user_authentications.find(params[:id])
    provider = user_authentication.provider
    user_authentication.destroy
    options = { :type => :success, 
                :root => :false, 
                :status => :ok,
                :message => m("user_authentication.#{provider}", "destroy") }
    render_json(nil, options)
  end
  
end
