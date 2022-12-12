class Communication::Website::Permalink::Teacher < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_teachers?
  end

  def self.static_config_key
    :teachers
  end

  # /equipe/:slug/programs/
  # FIXME
  def self.pattern_in_website(website)
    "#{website.special_page(:persons).path_without_language}:slug/programs/"
  end
end