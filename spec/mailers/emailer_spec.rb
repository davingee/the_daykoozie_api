require "spec_helper"

describe Emailer do

  describe "contact_rumorsource" do
    let(:contact) { create(:contact) }
    let(:mail) { Emailer.contact_us(contact) }

    it "sends team@rumorsource.com an email with contact info" do
      mail.subject.should eq(m("emailer.contact_us", "subject"))
      mail.to.should eq(["team@rumorsource.com"])
      mail.from.should eq(["foo@bar.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match(contact.name)
      mail.body.encoded.should match(contact.email)
      mail.body.encoded.should match(contact.body)
      mail.body.encoded.should match("http://localhost:3000/public/logo.png")
    end

  end


  describe "welcome" do
  
    let(:user) { create(:user) }    
    let(:mail) { Emailer.welcome(user) }
  
    it "sends user welcome letter if first time created" do
      mail.subject.should eq(m("emailer.welcome", "subject"))
      mail.to.should eq([user.email])
      mail.from.should eq(["no_reply@rumorsource.com"])
    end
  
    it "renders the body" do
      mail.body.encoded.should match(user.name)
      mail.body.encoded.should match("http://localhost:3000/public/logo.png")
      mail.body.encoded.should match("http://localhost:3000/campaigns")
    end
  
  end
  
  
  # describe "add_user_to_campaign" do
  # 
  #   let(:campaign_user_role) { create(:campaign_user_role) }    
  #   let(:mail) { Emailer.add_user_to_campaign(campaign_user_role) }
  # 
  #   it "sends individuals who have been added a role to a campaign." do
  #     mail.subject.should eq("#{campaign_user_role.inviter.name} invited you to a campaign")
  #     mail.to.should eq([campaign_user_role.their_email])
  #     mail.from.should eq(["no_reply@rumorsource.com"])
  #   end
  # 
  #   it "renders the body" do
  #     mail.body.encoded.should match(campaign_user_role.inviter.user.name)
  #     mail.body.encoded.should match(campaign_user_role.their_email)
  #     mail.body.encoded.should match("#{root_url}assets/rails.png")
  #   end
  # 
  # end

end
