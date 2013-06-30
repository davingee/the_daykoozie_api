class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include CanCan::ControllerAdditions

##### ERRORS
  # rescue_from ActionDispatch::Cookies::CookieOverflow, :with => :render_not_found # chnage to have mailer
  # rescue_from ActionController::NoMethodError, :with => :render_not_found
  # rescue_from AbstractController::ActionNotFound, :with => :render_not_found
  # rescue_from ActionController::RoutingError, :with => :render_not_found_2
  # [ActiveRecord::RecordNotFound, ActionController::RoutingError, NoMethodError]
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    message = m("rescue", "RecordNotFound")
    message = "#{exception.inspect} #{message}" if show_exception?
    render_not_found(message, :not_found)
  end
  
  rescue_from ActionController::RoutingError do |exception|
    message = m("rescue", "RoutingError")
    message = "#{exception.inspect} #{message}" if show_exception?
    render_not_found(message, :bad_request)
  end

  rescue_from NoMethodError do |exception|
    message = m("rescue", "NoMethodError")
    message = "#{exception.inspect} #{message}" if show_exception?
    render_not_found(message, :internal_server_error)
  end

  rescue_from ActionController::UnknownController do |exception|
    message = m("rescue", "UnknownController")
    message = "#{exception.inspect} #{message}" if show_exception?
    render_not_found(message, :internal_server_error)
  end

  rescue_from AbstractController::ActionNotFound do |exception|
    message = m("rescue", "ActionNotFound")
    message = "#{exception.inspect} #{message}" if show_exception?
    render_not_found(message, :not_found)
  end

  rescue_from ActionView::MissingTemplate do |exception|
    message = m("rescue", "MissingTemplate")
    message = "#{exception.inspect} #{message}" if show_exception?
    render_not_found(message, :not_found)
  end

  rescue_from CanCan::AccessDenied do |exception|
    message = exception.message
    message = "#{exception.inspect} #{message}" if show_exception?
    render_not_found(message, :unauthorized)
  end

  def show_exception?
    (Rails.env.development? or Rails.env.test?) ? true : false
  end

  def render_not_found(message, status)
    options = { :type => :error, :root => :false, :status => status, :message => message }
    render_json(nil, options)
  end

##### ERRORS END

  def render_json(resource=nil, options)
    meta_options = options[:message].nil? ? {:type => options[:type]} : {:type => options[:type], :content => options[:message]}
    meta = {:meta => meta_options, :meta_key => 'message'}
    if resource.blank?
      render :json => { :message => meta_options }, :status => options[:status]
    else
      other_options = options[:serializer].nil? ? 
        {:root => options[:root], :status => options[:status]} : 
        {:root => options[:root], :serializer => options[:serializer], :status => options[:status]}
      render meta.merge(:json => resource).merge(other_options)
    end
  end

  # private
  # protected
  def authenticate_failure_response
    options = { :type => :error, 
                :root => :false, 
                :status => :unauthorized, 
                :message => m("user", "unauthorized") }
    render_json(nil, options)
  end


  def require_basic_authentication!
    return true if current_user
    return http_basic_authentication ? true : authenticate_failure_response
  end

  def http_basic_authentication
    return nil unless request.env["HTTP_AUTHORIZATION"] =~ /Basic/
    authenticate_with_http_basic do |username, password|
      return nil if username.blank? or password.blank?
      authentificated = (username == "angular") and (password == "angular_secret")
      return nil unless authentificated
      authentificated
    end
  end

  def require_current_user!
    return current_user ? true : authenticate_failure_response
  end

  def current_user
    return @current_user unless @current_user.blank?
    return nil unless request.env["HTTP_AUTHORIZATION"] =~ /Token/
      authenticate_with_http_token do |token, options|
      return nil if token.blank?
      @current_user ||= User.find_by_authentication_token(token)
      return @current_user.blank? ? nil : @current_user
    end
  end
  
  def m(category, kind)
    I18n.translate "#{category}.#{kind}"  
  end
  
  def base_url
    request.protocol + request.host_with_port
  end

  def format_json?
    return true if request.format == "application/json"
  end

  def ip_address
    (Rails.env.development? or Rails.env.test?) ? '206.127.79.163' : (env['HTTP_X_REAL_IP'] ||= env['REMOTE_ADDR'])
  end

  def referer
    (Rails.env.development? or Rails.env.test?) ? 'http://facebook.com' : request.env['HTTP_REFERER']
  end

  def user_agent
    request.env['HTTP_USER_AGENT']
  end

end
