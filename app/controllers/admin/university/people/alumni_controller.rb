class Admin::University::People::AlumniController < Admin::University::ApplicationController
  load_and_authorize_resource class: University::Person::Alumnus,
                              through: :current_university,
                              through_association: :people

  has_scope :for_search_term

  def index
    @alumni = apply_scopes(@alumni).alumni
                     .accessible_by(current_ability)
                     .ordered
                     .page(params[:page])
    breadcrumb
  end

  def show
    @cohorts = @alumnus.cohorts.ordered.page(params[:cohorts_page])
    breadcrumb
  end

  def edit_cohorts
    breadcrumb
    add_breadcrumb t('edit')
  end

  def update_cohorts
    # TODO
    # if @alumnus.update(alumnus_params)
    #   redirect_to [:admin, @alumnus],
    #               notice: t('admin.successfully_updated_html', model: @alumnus.to_s)
    # else
    #   render :edit
    #   breadcrumb
    #   add_breadcrumb t('edit')
    # end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  University::Person::Alumnus.model_name.human(count: 2),
                    admin_university_people_alumni_path
    add_breadcrumb @alumnus, admin_university_person_alumnus_path(@alumnus) if @alumnus
  end

  def alumnus_params
    # TODO: Permit nested attrs
    params.require(:university_person_alumnus)
          .permit()
  end
end