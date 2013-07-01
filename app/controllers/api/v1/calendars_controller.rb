class Api::V1::CalendarsController < ApplicationController

  before_filter :require_current_user!, :only => [:create, :edit, :update, :destroy]
  # before_filter :require_basic_authentication!, :only => [:index, :show]

  def feed
    @title = "Daykoozie"
    @calendars = Calendar.not_secret.order("updated_at desc")
    # this will be our Feed's update timestamp
    @updated = @calendars.first.updated_at unless @calendars.empty?
    render :atom => @calendars 
    
  end

  def index
    calendars = Calendar.not_secret.search(params[:search]).page params[:page]
    options = { :type => :success, 
                :root => :calendars, 
                :status => :ok }
    render_json(calendars, options)
  end

  def show
    calendar = Calendar.find(params[:id])
    authorize! :read, calendar, :message => m("calendar", "unauthorized")
    calendar.show_events = true
    options = { :type => :success, :root => :calendar, :status => :ok }
    render_json(calendar, options)

  end

  def edit
    calendar = Calendar.find(params[:id])
    authorize! :edit, calendar, :message => m("calendar", "unauthorized")
    options = { :type => :success, :root => :calendar, :status => :ok }
    render_json(calendar, options)
  end

  def create
    calendar = current_user.calendars.new(params[:calendar])
    
    if calendar.save
      render_json(calendar, :status => :ok, :type => :success, :root => :calendar, 
        :message => m("calendar", "create") )
    else
      render_json(calendar, :status => :conflict, :type => :error, :root => :calendar, 
        :message => calendar.errors.as_json)
    end

  end

  def update
    calendar = Calendar.find(params[:id])
    authorize! :update, calendar, :message => m("calendar", "unauthorized")

    if calendar.update_attributes(params[:calendar])
      render_json(calendar,  :status => :ok, :type => :success, :root => :calendar, 
        :message => m("calendar", "update") )
    else
      render_json(calendar, :status => :conflict, :type => :error, :root => :calendar, 
        :message => calendar.errors.as_json)
    end

  end

  def destroy
    calendar = Calendar.find(params[:id])
    authorize! :destroy, calendar, :message => m("calendar", "unauthorized")
    
    calendar.destroy
    if Calendar.where(:id => params[:id]).blank?
      render_json(nil, :status => :ok, :type => :success, :root => false, :message => m("calendar", "destroy"))
    else
      render_json(calendar, :status => :conflict, :type => :error, :root => :calendar, :message => calendar.errors.as_json)
    end
    
  end


end
