class Api::V1::UsersController < ApplicationController

  before_filter :require_current_user!, :only => [:edit, :update, :destroy]
  before_filter :require_basic_authentication!, :only => [:create]

  def index
    users = User.to_show
    options = { :type => :success, 
                :root => :users, 
                :status => :ok }
    render_json(users, options)
  end

  def show
    user = User.to_show.find(params[:id])
    options = { :type => :success, 
                :root => :user, 
                :status => :ok }
    render_json(user, options)
  end

  def create
    user = User.new(params[:user])
    if user.save
      user.ensure_authentication_token!
      Emailer.welcome(user).deliver
      options = { :type => :success, 
                  :root => :user, 
                  :status => :ok,
                  :message => m("user", "create") }
      render_json(user, options)
    else
      options = { :type => :error, 
                  :root => :user, 
                  :status => :conflict,
                  :message => user.errors.as_json }
      render_json(user, options)
    end
  end

  def edit
    authorize! :manage, current_user, :message => m("user", "unauthorized")
    
    options = { :type => :success, 
                :root => :user, 
                :status => :ok }
    render_json(current_user, options)
  end

  def update
    authorize! :manage, current_user, :message => m("user", "unauthorized")
    
    if current_user.update_attributes(params[:user])
      options = { :type => :success, 
                  :root => :user, 
                  :status => :ok,
                  :message => m("user", "update") }
      render_json(current_user, options)
    else
      options = { :type => :error, 
                  :root => :user, 
                  :status => :conflict,
                  :message => current_user.errors.as_json }
      render_json(current_user, options)
    end
  end

  def destroy
    authorize! :manage, current_user, :message => m("user", "unauthorized")
    current_user.soft_delete = true
    current_user.authentication_token = nil
    if current_user.save
      options = { :type => :success, 
                  :root => :false, 
                  :status => :ok,
                  :message => m("user", "destroy") }
      render_json(nil, options)
    else
      options = { :type => :error, 
                  :root => :user, 
                  :status => :conflict,
                  :message => current_user.errors.as_json }
      render_json(current_user, options)
    end
  end

end
