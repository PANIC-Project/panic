class OverviewController < ApplicationController
  def index
    @stats = StatOverview.last
  end
end
