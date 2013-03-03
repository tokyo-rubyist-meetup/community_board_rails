class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar_url

  def avatar_url
    "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(object.email.downcase)}"
  end
end
