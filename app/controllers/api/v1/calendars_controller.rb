class Api::V1::CalendarsController < ApplicationController

  before_filter :require_user, :except => [:index, :show, :feed]

  def feed
    @title = "Daykoozie"
    @calendars = Calendar.order("updated_at desc")
    # this will be our Feed's update timestamp
    @updated = @calendars.first.updated_at unless @calendars.empty?
    render :atom => @calendars 
    
  end

  def index
    calendars = Calendar.search(params[:search]).page params[:page]
    options = { :type => :success, 
                :root => :calendars, 
                :status => :ok }
    render_json(calendars, options)
  end

  def show
    calendar = Calendar.find(params[:id])
    authorize! :read, calendar, :message => m("calendar", "unauthorized")
    calendar.show_events = true
    options = { :type => :success, 
                :root => :calendars, 
                :status => :ok }
    render_json(calendar, options)

  end

  def new
    @calendar = current_user.calendars.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @calendar }
    end
  end

  def edit
    @calendar = Calendar.find(params[:id])
    authorize! :edit, @calendar, :message => "You do not have permision to manage this calendar."
  end

  def create
    @calendar = current_user.calendars.new(params[:calendar])
    
    respond_to do |format|
      if @calendar.save!
        format.html { redirect_to @calendar, notice: 'Calendar was successfully created.' }
        format.json { render json: @calendar, status: :created, location: @calendar }
      else
        format.html { render action: "new" }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @calendar = Calendar.find(params[:id])
    authorize! :update, @calendar, :message => "You do not have permision to manage this calendar."

    respond_to do |format|
      if @calendar.update_attributes(params[:calendar])
        format.html { redirect_to @calendar, notice: 'Calendar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @calendar = current_user.calendars.find(params[:id])
    authorize! :destroy, @calendar, :message => "You do not have permision to do this."
    
    @calendar.destroy

    respond_to do |format|
      format.html { redirect_to calendars_url }
      format.json { head :no_content }
    end
  end


end
