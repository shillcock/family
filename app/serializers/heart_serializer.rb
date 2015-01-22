class HeartSerializer < ActiveModel::Serializer
  attributes :id, :lovable
  has_one :user
end
