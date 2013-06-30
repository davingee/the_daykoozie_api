require 'spec_helper'
# include 'validation_helper'

describe User do

  context 'associations' do
    
    context 'belongs_to' do
      # it { has_the_association?(:belongs_to, :company_application) }
    end

    context 'has_many' do
      it { has_the_association?(:has_many, :contacts) }
      it { has_the_association?(:has_many, :campaigns) }
      it { has_the_association?(:has_many, :shares) }
    end
    
    context 'has_one' do
      # it { has_the_association?(:has_one, :user_address) }
      # it { has_the_association?(:has_one, :ninja_application) }
    end

  end

  context 'validations' do
    context 'presence of' do
      it { validates_presence_of(:first_name, "Scott") }
      it { validates_presence_of(:last_name, "Smith") }
    end
    
    context 'length of' do
      it {validates_length_of(:first_name, "*" * 10, "*" * 1)}
      it {validates_length_of(:first_name, "*" * 10, "*" * 52)}
      it {validates_length_of(:last_name, "*" * 10, "*" * 1)}
      it {validates_length_of(:last_name, "*" * 10, "*" * 52)}

      it "validates password mathces password_confirmation" do
        subject.password_confirmation = "testing"
        subject.password = "testing1"
        subject.valid?.should_not be_true
        subject.errors["password"].should_not be_empty

        subject.password_confirmation = "testing"
        subject.password = "testing"
        subject.valid?.should_not be_true
        subject.errors["password"].should be_empty
      end
      
      it "validates length of password" do
        subject.password_confirmation = "test"
        subject.password = "test"
        subject.valid?.should_not be_true
        subject.errors["password"].should_not be_empty
      end
      
      # it "validates if omniauth true or password present" do
      #   subject.omniauth = true
      #   subject.valid?.should_not be_true
      #   subject.errors["password"].should be_empty
      #   
      #   subject.omniauth = false
      #   subject.valid?.should_not be_true
      #   subject.errors["password"].should be_empty
      # 
      #   subject.omniauth = false
      #   subject.password = "test"
      #   subject.valid?.should_not be_true
      #   subject.errors["password"].should_not be_empty
      # end
      
    end
  end

end
