class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.is('admin')
      can :manage, :all
    end

    is_valid = user.id.blank? ? false : true
    define_event_abilities(user, is_valid)
    define_calendar_abilities(user, is_valid)
    define_user_abilities(user)
  end
  
  def define_user_abilities(user)
    can [:manage], User, :id => user.id
  end
  
  def define_calendar_abilities(user, is_registered)
    can :read, :all
        
    cannot :read, Calendar do |calendar|
      calendar.secret? and !calendar.calendar_role?(user,  [:owner, :admin, :manager])
    end

    if is_registered
      can :create, Calendar

      can :update, Calendar do |calendar|
        calendar.calendar_role?(user, [:owner, :admin, :manager])
      end

      can :manage, Calendar do |calendar|
        calendar.calendar_role?(user, [:owner])
      end

    end
  end
  
  def define_event_abilities(user, is_registered)
    can :read, :all
    
    cannot :read, Event do |event|
      event.calendar.secret? and !event.calendar.calendar_role?(user,  [:owner, :admin, :manager])
    end
  
    if is_registered
  
      can [:create, :new], Event do |event|
        event.calendar.calendar_role?(user,  [:owner, :admin, :manager])
      end
  
      can :update, Event do |event|
        event.calendar.calendar_role?(user,  [:owner, :admin]) or event.user_id == user.id
      end
  
      # can :manage, Event do |event|
      #   event.calendar.calendar_role?(user, :owner)
      # end
  
    end
  end

end
