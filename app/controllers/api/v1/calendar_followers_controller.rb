class Api::V1::CalendarFollowersController < ApplicationController
  before_filter :require_current_user!, :only => [:create, :destroy]

  def index
    calendar = Calendar.find(params[:calendar_id])
    calendar_followers = calendar.calendar_followers
    render_json(calendar_followers, :status => :ok, :type => :success, :root => :calendar_followers)
  end

  def create
    calendar = Calendar.find(params[:calendar_id])
    current_user.follow_calendar!(calendar)
    render_json(calendar_follower, :status => :ok, :type => :success, :root => :calendar_follower, :message => m("calendar_follower", "create"))
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