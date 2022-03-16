class Admin::University::Person::AlumniController < Admin::University::ApplicationController
  before_action :load_alumnus, only: [:show, :edit, :update]

  def index
    @alumni = current_university.people
                                .alumni
                                .accessible_by(current_ability)
                                .ordered
                                .page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def update
    if @alumnus.update(alumnus_params)
      redirect_to [:admin, @alumnus],
                  notice: t('admin.successfully_updated_html', model: @alumnus.to_s)
    else
      render :edit
      breadcrumb
      add_breadcrumb t('edit')
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  University::Person::Alumnus.model_name.human(count: 2),
                    admin_university_person_alumni_path
    breadcrumb_for  @alumnus
  end

  def load_alumnus
  end

  def alumnus_params
    params.require(:university_person_alumnus)
          .permit()
  end
end