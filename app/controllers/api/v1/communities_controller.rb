class Api::V1::CommunitiesController < ApplicationController
  respond_to :json
  def index
    @communities = Community.all
    respond_with @communities
  end
end
