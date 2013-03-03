class Api::V1::PostsController < ApplicationController
  doorkeeper_for :all
  before_filter :load_community
  respond_to :json
  def index
    @posts = @community.posts.new_to_old
    respond_with @posts
  end
end

