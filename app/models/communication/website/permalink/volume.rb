# == Schema Information
#
# Table name: communication_website_permalinks
#
#  id            :uuid             not null, primary key
#  about_type    :string           not null, indexed => [about_id]
#  is_current    :boolean          default(TRUE)
#  path          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             not null, indexed => [about_type]
#  university_id :uuid             not null, indexed
#  website_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_permalinks_on_about          (about_type,about_id)
#  index_communication_website_permalinks_on_university_id  (university_id)
#  index_communication_website_permalinks_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_e9646cce64  (university_id => universities.id)
#  fk_rails_f389ba7d45  (website_id => communication_websites.id)
#
class Communication::Website::Permalink::Volume < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.about.is_a? Research::Journal
  end

  def self.static_config_key
    :volumes
  end

  # /volumes/:slug/
  def self.pattern_in_website(website)
    "/#{website.special_page(Communication::Website::Page::ResearchVolume).slug_with_ancestors}/:year-:slug/"
  end

  protected

  def substitutions
    {
      year: about.published_at.strftime("%Y"),
      slug: about.slug
    }
  end
end