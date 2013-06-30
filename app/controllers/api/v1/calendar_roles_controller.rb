class Api::V1::CalendarRolesController < ApplicationController

  before_filter :require_user

  def index
    @calendar = Calendar.find(params[:calendar_role][:calendar_id])
    current_user.follow_calendar!(@calendar)
    respond_to do |format|
      format.html { redirect_to @calendar }
      format.js
    end
  end

  def create
    @calendar = Calendar.find(params[:calendar_role][:calendar_id])
    current_user.follow_calendar!(@calendar)
    respond_to do |format|
      format.html { redirect_to @calendar }
      format.js
    end
  end

  def update
    @calendar = Calendar.find(params[:calendar_role][:calendar_id])
    current_user.follow_calendar!(@calendar)
    respond_to do |format|
      format.html { redirect_to @calendar }
      format.js
    end
  end

  def destroy    
    @calendar_role = current_user.calendar_roles.find(params[:id])
    @calendar = @calendar_role.calendar
    current_user.unfollow_calendar!(@calendar_role)
    respond_to do |format|
      format.html { redirect_to @calendar }
      format.js
    end
  end
  
end
