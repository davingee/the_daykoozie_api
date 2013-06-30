require 'spec_helper'

describe UserAuthentication do

  context 'associations' do
    
    context 'belongs_to' do
      it { has_the_association?(:belongs_to, :user) }
    end
  
  end
  
  context 'validations' do
    context 'presence of' do
      it { validates_presence_of(:uid, "12345") }
      it { validates_presence_of(:provider, "facebook") }
    end
    
  end

end
