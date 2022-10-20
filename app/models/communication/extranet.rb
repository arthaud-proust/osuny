# == Schema Information
#
# Table name: communication_extranets
#
#  id                          :uuid             not null, primary key
#  about_type                  :string           indexed => [about_id]
#  domain                      :string
#  has_sso                     :boolean          default(FALSE)
#  name                        :string
#  registration_contact        :string
#  sso_cert                    :text
#  sso_inherit_from_university :boolean          default(FALSE)
#  sso_mapping                 :jsonb
#  sso_name_identifier_format  :string
#  sso_provider                :integer          default("saml")
#  sso_target_url              :integer          default(0)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  about_id                    :uuid             indexed => [about_type]
#  university_id               :uuid             not null, indexed
#
# Indexes
#
#  index_communication_extranets_on_about          (about_type,about_id)
#  index_communication_extranets_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_c2268c7ebd  (university_id => universities.id)
#
class Communication::Extranet < ApplicationRecord
  include WithAbouts
  include WithSso
  include WithUniversity

  validates_presence_of :name, :domain

  has_one_attached_deletable :logo

  scope :ordered, -> { order(:name) }
  scope :for_search_term, -> (term) {
    where("
      unaccent(communication_extranets.domain) ILIKE unaccent(:term) OR
      unaccent(communication_extranets.name) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def self.with_host(host)
    find_by domain: host
  end

  def should_show_years?
    # For a single program, year is like cohort
    return false if about.is_a? Education::Program
    # if a school has a single program, same thing
    about.programs.many?
  end

  def alumni
    about&.university_person_alumni
  end

  def cohorts
    about&.cohorts
  end

  def years
    about&.academic_years
  end

  def organizations
    about&.alumni_organizations
  end

  def url
    "https://#{domain}"
  end

  def to_s
    "#{name}"
  end
end
