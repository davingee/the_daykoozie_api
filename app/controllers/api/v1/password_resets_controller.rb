class Api::V1::PasswordResetsController < ApplicationController

  before_filter :require_basic_authentication!, :only => [:create, :update]

  def create

    user = User.find_by_email(params[:email])
    # redis
    if user
      user.send_password_reset 
      options = { :type => :success, 
                  :root => :false, 
                  :status => :ok,
                  :message => m("password", "create") }
    else
      options = { :type => :error, 
                  :root => :false, 
                  :status => :not_found,
                  :message => m("password", "not_found") }
    end
    render_json(nil, options)

  end

  def update
    if params[:user][:password].blank? or params[:user][:password_confirmation].blank?
      options = { :type => :error, 
                  :root => :false, 
                  :status => :conflict,
                  :message => m("password", "no_password_or_confirmation") }

      render_json(nil, options)
      return
    end
    
    user = User.find_by_password_reset_token!(params[:id])

    if user.password_reset_sent_at < 2.hours.ago
 
      options = { :type => :error, 
                  :root => :user, 
                  :status => :conflict,
                  :message => m("password", "update_expired") }

      render_json(user, options)
    elsif user.update_attributes(params[:user])
      
      user.ensure_authentication_token!
      user.send_auth_token = true
      options = { :type => :success, 
                  :root => :user, 
                  :status => :ok,
                  :message => m("password", "update") }

      render_json(user, options)
    else

      options = { :type => :error, 
                  :root => :user, 
                  :status => :conflict,
                  :message => user.errors.as_json }

      render_json(user, options)
    end

  end

end
