require 'development_mail_interceptor'
DaykoozieCom::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  SCOTT = { :email => "scott@scoran.com", :first_name => "scott", :last_name => "smith", :password => "fucker", :password_confirmation  => "fucker"}
  CMMARTIN = { :email => 'cmmartin24@gmail.com', :first_name => 'Charlie', :last_name => 'Martin', :password => 'rumorsource', :password_confirmation => 'rumorsource' }

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
  
  
  # Action mailer settings
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  Rails.application.routes.default_url_options = config.action_mailer.default_url_options # because this is what Resque looks for
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :authentication       => "plain",
    :enable_starttls_auto => true,
    :user_name => ENV["GMAIL_USERNAME"],
    :password => ENV["GMAIL_PASSWORD"]
  }
  ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
  
end
