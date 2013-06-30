module ControllerMacros
  
  def set_basic_auth
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials 'angular', 'angular_secret'
    request.env['HTTP_AUTHORIZATION'] = credentials
  end

  def set_basic_auth_with_user(hash={})
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials 'angular', 'angular_secret'
    request.env['HTTP_AUTHORIZATION'] = credentials
    user = hash[:with_omniauth] ? FactoryGirl.create(:user, :with_omniauth) : FactoryGirl.create(:user)
  end

  def set_token_auth_with_user(hash={})
    # user = hash[:with_omniauth] ? FactoryGirl.create(:user, :with_omniauth) : FactoryGirl.create(:user)
    if hash[:with_omniauth]
      user = FactoryGirl.create(:user, :with_omniauth)
    elsif hash[:with_credit_card]
      user = FactoryGirl.create(:user, :with_credit_card)
    else
      user = FactoryGirl.create(:user)
    end
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.authentication_token)
    user
  end

  def set_token_auth(user)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.authentication_token)
  end

  def m(category, kind)
    I18n.translate "#{category}.#{kind}"  
  end
  
end
