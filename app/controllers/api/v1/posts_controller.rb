class Api::V1::PostsController < Api::V1::ApiController
  doorkeeper_for :create
  before_filter :load_community
  respond_to :json
  def index
    @posts = @community.posts.new_to_old
    respond_with @posts
  end

  def create
    @post = @community.posts.build(post_params)
    @post.user = current_resource_owner
    @post.save
    respond_with @post
  end

  private

  def post_params
    params.require(:post).permit(:text)
  end
end

