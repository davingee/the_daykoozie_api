class UserCreditCardSerializer < ActiveModel::Serializer
  attributes :id, :name, :last_four, :card_type, :card_valid, :stripe_customer_token, :stripe_card_token, :user_id, :exp_month, :exp_year
end
