class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def load_community
    @community = Community.find(params[:community_id])
  end
end
