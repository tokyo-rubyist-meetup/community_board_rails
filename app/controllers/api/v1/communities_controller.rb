class Api::V1::CommunitiesController < Api::V1::ApiController
  respond_to :json
  def index
    @communities = Community.all
    respond_with @communities
  end
end
