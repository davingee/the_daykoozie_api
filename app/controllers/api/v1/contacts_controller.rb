class ContactsController < ApplicationController

  before_filter :require_basic_authentication!, :only => [:create, :new]

  def new
    if current_user
      contact = current_user.contacts.new
      contact.email = current_user.email
      contact.name = current_user.name
    else
      contact = Contact.new
    end
    options = { :type => :success, 
                :root => :contact, 
                :status => :ok }
    render_json(contact, options)
  end

  def create
    contact = current_user ? current_user.contacts.new(params[:contact]) : Contact.new(params[:contact])
    contact.ip_address = ip_address
    if contact.save
      # Emailer.contact_us(contact).deliver
      options = { :type => :success, 
                  :root => :contact, 
                  :status => :ok,
                  :message => m("contact", "create") }
      render_json(contact, options)
    else
      options = { :type => :error, 
                  :root => :contact, 
                  :status => :conflict,
                  :message => contact.errors.as_json }
      render_json(contact, options)
    end
  end

end
