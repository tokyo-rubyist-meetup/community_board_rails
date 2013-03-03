class CommunitySerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :post_count

  def post_count
    object.posts.count
  end
end
