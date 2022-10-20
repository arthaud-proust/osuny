SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::BootstrapRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'
  navigation.items do |primary|
    primary.item  :person,
                  University::Person::Alumnus.model_name.human(count: 2),
                  university_persons_path
    primary.item  :years,
                  Education::AcademicYear.model_name.human(count: 2),
                  education_academic_years_path if current_extranet.should_show_years?
    primary.item  :cohorts,
                  Education::Cohort.model_name.human(count: 2),
                  education_cohorts_path
    primary.item  :organizations,
                  University::Organization.model_name.human(count: 2),
                  university_organizations_path
    primary.item  :account,
                  current_user.to_s,
                  nil do |secondary|
      secondary.item  :account,
                    t('extranet.account.my'),
                    account_path
      secondary.item  :personal_data,
                    t('extranet.personal_data.title'),
                    personal_data_path
    end
  end
end