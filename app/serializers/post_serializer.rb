class PostSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at

  has_one :user

end
