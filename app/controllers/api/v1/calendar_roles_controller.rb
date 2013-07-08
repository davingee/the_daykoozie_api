class Api::V1::CalendarRolesController < ApplicationController
                
  before_filter :require_current_user!, :only => [:index, :update, :create, :destroy]

  def index
    calendar = Calendar.find(params[:calendar_id])
    authorize! :update, calendar, :message => m("calendar", "unauthorized")
    calendar_roles = calendar.calendar_roles
    render_json(calendar_roles, :status => :ok, :type => :success, :root => :calendar_roles)
    
  end
  
  def create
    calendar = Calendar.find(params[:calendar_id])
    authorize! :update, calendar, :message => m("calendar", "unauthorized")
    calendar_role = calendar.calendar_roles.find_or_initialize_by_user_id(params[:calendar_role][:user_id])
    calendar_role.role = params[:calendar_role][:role].to_sym
    if calendar_role.save
      render_json(calendar_role, :status => :ok, :type => :success, :root => :calendar_role, 
        :message => m("calendar_role", "create") )
    else
      render_json(calendar_role, :status => :conflict, :type => :error, :root => :calendar_role, 
        :message => calendar_role.errors.as_json)
    end

  end

  def destroy
    calendar = Calendar.find(params[:calendar_id])
    authorize! :update, calendar, :message => m("calendar", "unauthorized")
    calendar_role = calendar.calendar_roles.find(params[:id])
    if calendar_role.role == :owner
      render_json(nil, :status => :unauthroized, :type => :error, :root => false, 
        :message => m("calendar", "unauthorized") )
      return
    end
    calendar_role.destroy
    unless calendar.calendar_roles.find(params[:id])
      render_json(false, :status => :ok, :type => :success, :root => false, 
        :message => m("calendar_role", "destroy") )
    else
      render_json(calendar_role, :status => :conflict, :type => :error, :root => :calendar_role, 
        :message => calendar_role.errors.as_json)
    end
  end
  
end
