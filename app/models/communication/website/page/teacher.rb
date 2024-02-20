class Communication::Website::Page::Teacher < Communication::Website::Page

  def is_necessary_for_website?
    website.about && website.about&.respond_to?(:teachers)
  end

  # Not listed in any menu because it makes "Équipe" unclickable (opens submenu)
  def default_menu_identifier
    ''
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.teachers.where(language_id: language_id).map(&:teacher)
  end

  def git_path_relative
    'teachers/_index.html'
  end

  protected

  def default_parent
    website.special_page(Communication::Website::Page::Person, language: language)
  end
end
