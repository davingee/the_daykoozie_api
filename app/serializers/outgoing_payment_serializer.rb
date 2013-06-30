class OutgoingPaymentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :amount, :token, :provider, :email
end
