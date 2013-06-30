class Api::V1::TokensController  < ApplicationController
  before_filter :require_current_user!, :only => [:destroy]
  before_filter :require_basic_authentication!, :only => [:create]

  def create
    email = params[:email]
    password = params[:password]

    if request.format != :json
      options = { :type => :error, 
                  :root => :false, 
                  :status => :not_acceptable,
                  :message => m("rescue", "json") }
      render_json(nil, options)
      return
    end

    if email.nil? or password.nil?
      options = { :type => :error, 
                  :root => :false, 
                  :status => :bad_request,
                  :message => m("token", "must_contain") }
      render_json(nil, options)
       return
    end
 
     user = User.find_by_email(email.downcase)
 
    if user.nil?
      logger.info("User #{email} failed signin, user cannot be found.")
      options = { :type => :error, 
                  :root => :false, 
                  :status => :unauthorized,
                  :message => m("token", "invalid") }
      render_json(nil, options)
      return
    end
 
    if user && user.authenticate(password)
      user.ensure_authentication_token!
      user.send_auth_token = true
      options = { :type => :success, 
                  :root => :user, 
                  :status => :ok,
                  :message => m("token", "create") }
      render_json(user, options)

    else
      logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
      options = { :type => :error, 
                  :root => :false, 
                  :status => :unauthorized,
                  :message => m("token", "invalid") }
      render_json(nil, options)

    end

  end
 
  def destroy
    authorize! :manage, current_user, :message => m("user", "unauthorized")
    current_user.authentication_token = nil
    current_user.save
    @current_user = nil
    options = { :type => :success, 
                :root => :false, 
                :status => :ok,
                :message => m("token", "destroy") }
    render_json(nil, options)
  end
 
end