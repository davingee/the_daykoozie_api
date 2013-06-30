require 'spec_helper'

describe UserRole do

  context 'associations' do
    
    context 'belongs_to' do
      # it { has_the_association?(:belongs_to, :company_application) }
    end

    context 'has_many' do
      # it { has_the_association?(:has_many, :shares) }
    end
    
    context 'has_one' do
      # it { has_the_association?(:has_one, :ninja_application) }
    end

  end

  context 'validations' do
    context 'presence of' do
      # it { validates_presence_of(:last_name, "Smith") }
    end
    
    context 'length of' do
      # it {validates_length_of(:first_name, "*" * 10, "*" * 1)}
    end
  end

end
