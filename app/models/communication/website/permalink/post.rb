class Communication::Website::Permalink::Post < Communication::Website::Permalink
  def self.required_for_website?(website)
    website.has_communication_posts?
  end

  def self.static_config_key
    :posts
  end

  # /actualites/2022/10/21/un-article/
  def self.pattern_in_website(website)
    "#{website.special_page(:communication_posts).path_without_language}:year/:month/:day/:slug/"
  end

  protected

  def published?
    website.id == about.communication_website_id && about.published && about.published_at
  end

  def published_path
    pattern
      .gsub(":year/:month/:day", about.published_at.strftime("%Y/%m/%d"))
      .gsub(":slug", about.slug)
  end
end
