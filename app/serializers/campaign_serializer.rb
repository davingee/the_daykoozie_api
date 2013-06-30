class CampaignSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :budget, :title, :blurb, :content, :published, :campaign_promo_code, :url, :local, :image, :soft_delete, :wants_to_spend, :amount_to_ancestor, :secret, :start_date, :campaign_type
end
