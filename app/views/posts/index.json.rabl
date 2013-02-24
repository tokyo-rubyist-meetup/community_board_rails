collection @posts
attributes :id, :text, :created_at
child :user do 
  attributes :id, :name
  node(:avatar_url) {|user| "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.downcase)}" }
end
