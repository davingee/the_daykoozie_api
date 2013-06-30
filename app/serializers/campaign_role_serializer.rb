class CampaignRoleSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :campaign_id, :role, :email, :inviter_id
end
