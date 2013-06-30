class DevelopmentMailInterceptor
  def self.delivering_email(message)
    # gets the username of the computer username you are logged in as if you are using windows just use ENV['USERNAME']
    message.subject = "#{message.to} #{message.subject}"
    if ENV['USER'] == "scott"
      message.to = "scottsmit@gmail.com"
      message.subject
    elsif ENV['USER'] == "cmmartin"
      message.to = "cmmartin24@gmail.com"
      message.subject
    elsif ENV['USER'] == "your_user"
      message.to = "your@email.com"
      message.subject
    end
  end
end
