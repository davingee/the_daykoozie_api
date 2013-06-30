class Emailer < ActionMailer::Base
  layout 'emailer' # use awesome.(html|text).erb as the layout
  default from: "no_reply@daykoozie.com"

  def contact(contact)
    @contact = contact
    # attachments["some_attachment"] = File.read("#{Rails.root}/public/some_attachment")
    mail(
      :to => @contact.email,
      :subject => "Daykoozie has got a message"
    )
  end

  def friend_followed_calendar(user, calendar)
    @user.user
    @calendar = calendar
    mail(
      :to => @user.email,
      :subject => "#{event.user.name} created an event on #{event.calendar.title}"
    )
  end
    
  def welcome(user)
    @user = user
    mail(
      :to => @user.email,
      :subject => "Welcome to Daykoozie"
    )
  end

  def new_event(user, event)
    @user = user
    @event = event
    mail(
      :to => @user.email,
      :subject => "#{event.user.name} created an event on #{event.calendar.title}"
    )
  end
  
  def password_reset(user)
    subject = I18n.translate "emailer.password_reset.subject"  
    @user = user
    mail(
      :to => user.email,
      :subject => subject
    )
  end
  
end
