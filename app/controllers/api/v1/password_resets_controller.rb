class Api::V1::PasswordResetsController < ApplicationController

  before_filter :require_basic_authentication!, :only => [:create, :update]

  def create
    
    user = User.find_by_email(params[:email])
    # redis
    user.send_password_reset if user

    options = { :type => :success, 
                :root => :user, 
                :status => :ok,
                :message => m("password", "create") }

    render_json(user, options)

  end

  # def edit
  #   @user = User.find_by_password_reset_token!(params[:id])
  # end

  def update

    user = User.find_by_password_reset_token!(params[:id])

    if user.password_reset_sent_at < 2.hours.ago
 
      options = { :type => :error, 
                  :root => :user, 
                  :status => :not_ok,
                  :message => m("password", "update_expired") }

      render_json(user, options)
    elsif user.update_attributes(params[:user])
      
      user.ensure_authentication_token!
      
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
