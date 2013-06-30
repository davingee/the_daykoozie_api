require 'spec_helper'
require 'cancan/matchers'

def campaign_with_user(role=:admin)
  campaign = FactoryGirl.create(:campaign)
  user = campaign.user
  campaign_role = user.user_roles.create!(:role => role)
  campaign_role.inviter_id = campaign.user.id
  campaign_role.email = "the_foo@bar.com"
  campaign_role.save
  campaign
end

describe Ability do


  let(:user) { FactoryGirl.create(:user) }
  let(:ability) { Ability.new(user) }

  subject { ability }

  context 'when user has admin privileges' do
    before(:each) { user.user_roles.create(:role => :admin) { true } }
    it { should be_able_to :manage, :all }

    # context 'when user has not responded to an answer' do
    #   let(:answer) { build_stubbed :answer }
    #   before(:each) { answer.stub(:question_for) { nil } }
    # 
    #   it { should_not be_able_to :check, answer }
    # end
  end

  context 'when user is not an administrator' do
    # it { should be_able_to :index, Campaign }
    it { should be_able_to :read, Campaign }
    it { should be_able_to :read, Share }

    describe 'managing campaigns' do
      context 'when campaign has campaign_role of :manager' do
        campaign = campaign_with_user
        ability = Ability.new(campaign.user)
        
        it { should be_able_to :manage, campaign }
      end

      context 'when question is not for user' do
        let(:question) { build_stubbed :question }
        it { should_not be_able_to :manage, question }
      end

      it { should_not be_able_to :check, Answer }
    end

    context "when question's answer is closed" do
      let(:question) { build_stubbed :question }
      before(:each) { question.answer.stub(:closed?) { true } }
      it { should be_able_to :show, question }
    end

    context "when question's answer is not closed" do
      let(:question) { build_stubbed :question }
      before(:each) { question.answer.stub(:closed?) { false } }
      it { should_not be_able_to :show, question }
    end
  end
end
