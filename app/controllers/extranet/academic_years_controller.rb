class Extranet::AcademicYearsController < Extranet::ApplicationController
  load_and_authorize_resource class: Education::AcademicYear,
                              through: :current_university,
                              through_association: :academic_years

  def index
    @academic_years = about&.academic_years
                            .page(params[:page])
                            .per(20)
    @count = @academic_years.total_count
    breadcrumb
  end

  def show
    @cohorts = @academic_year.cohorts_in_context(current_context.about)
    @alumni = @academic_year.alumni_in_context(current_context.about)
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Education::AcademicYear.model_name.human(count: 2), education_academic_years_path
    add_breadcrumb @academic_year if @academic_year
  end
end
