require 'spec_helper'
# include 'validation_helper'

describe UserNotification do

  context 'associations' do
    
    context 'belongs_to' do
      # it { has_the_association?(:belongs_to, :company_application) }
    end

    context 'has_many' do
      # it { has_the_association?(:has_many, :user_roles) }
    end
    
    context 'has_one' do
      # it { has_the_association?(:has_one, :user_address) }
    end

  end

  context 'validations' do
    context 'presence of' do
      # it { validates_presence_of(:last_name, "Smith") }
    end
    
    context 'length of' do
      # it {validates_length_of(:last_name, "*" * 10, "*" * 52)}
      
    end
  end

end
