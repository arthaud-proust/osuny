class Extranet::HomeController < Extranet::ApplicationController
  def index
    return redirect_to admin_root_path unless current_extranet
    @cohorts = about&.cohorts.ordered.limit(5)
    @experiences = about&.experiences.ordered.limit(10)
  end
end
