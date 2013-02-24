collection @communities
attributes :id, :name, :created_at
node(:post_count) {|community| community.posts.count }
