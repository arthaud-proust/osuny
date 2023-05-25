# == Schema Information
#
# Table name: communication_websites
#
#  id                  :uuid             not null, primary key
#  about_type          :string           indexed => [about_id]
#  access_token        :string
#  git_branch          :string
#  git_endpoint        :string
#  git_provider        :integer          default("github")
#  in_production       :boolean          default(FALSE)
#  name                :string
#  plausible_url       :string
#  repository          :string
#  style               :text
#  style_updated_at    :date
#  theme_version       :string           default("NA")
#  url                 :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  about_id            :uuid             indexed => [about_type]
#  default_language_id :uuid             not null, indexed
#  university_id       :uuid             not null, indexed
#
# Indexes
#
#  index_communication_websites_on_about                (about_type,about_id)
#  index_communication_websites_on_default_language_id  (default_language_id)
#  index_communication_websites_on_university_id        (university_id)
#
# Foreign Keys
#
#  fk_rails_2b6d929310  (default_language_id => languages.id)
#  fk_rails_bb6a496c08  (university_id => universities.id)
#
class Communication::Website::Configs::Base < Communication::Website

  def self.polymorphic_name
    raise NotImplementedError
  end

  def git_path(website)
    raise NotImplementedError
  end

  def template_static
    raise NotImplementedError
  end

  ######
  # force dependencies & references to prevent multiple useless calls
  ######

  def dependencies
    []
  end

  def references
    []
  end

end