class CampaignPaymentSerializer < ActiveModel::Serializer
  attributes :id, :campaign_id, :amount, :transaction_id, :user_id
end
