class HomeController < ApplicationController
  def index
    @communities = Community.all
  end
end
