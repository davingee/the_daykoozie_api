class CampaignPrizeSerializer < ActiveModel::Serializer
  attributes :id, :name, :retail_price, :amount, :description, :image, :campaign_id, :prize_for, :prize_kind
end
