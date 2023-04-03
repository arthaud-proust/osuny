# == Schema Information
#
# Table name: university_organizations
#
#  id                 :uuid             not null, primary key
#  active             :boolean          default(TRUE)
#  address            :string
#  address_additional :string
#  address_name       :string
#  city               :string
#  country            :string
#  email              :string
#  kind               :integer          default("company")
#  latitude           :float
#  linkedin           :string
#  long_name          :string
#  longitude          :float
#  mastodon           :string
#  meta_description   :text
#  name               :string
#  nic                :string
#  phone              :string
#  siren              :string
#  slug               :string
#  summary            :text
#  text               :text
#  twitter            :string
#  url                :string
#  zipcode            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  university_id      :uuid             not null, indexed
#
# Indexes
#
#  index_university_organizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_35fcd198e0  (university_id => universities.id)
#
class University::Organization < ApplicationRecord
  include Sanitizable
  include WithBlobs
  include WithBlocks
  include WithConnections
  include WithCountry
  include WithGeolocation
  include WithPermalink
  include WithSlug
  include WithUniversity

  attr_accessor :created_from_extranet

  has_summernote :text

  has_and_belongs_to_many :categories,
                          class_name: 'University::Organization::Category',
                          join_table: :university_organizations_categories,
                          foreign_key: :organization_id
  has_many :experiences,
           class_name: 'University::Person::Experience',
           dependent: :destroy

  has_one_attached_deletable :logo
  has_one_attached_deletable :logo_on_dark_background

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :university_id
  validates :logo, size: { less_than: 1.megabytes }
  validates :logo_on_dark_background, size: { less_than: 1.megabytes }
  # Organization can be created from extranet with only their name. Be careful for future validators.
  # There is an attribute accessor above : `created_from_extranet`

  scope :ordered, -> { order(:name) }
  scope :for_kind, -> (kind) { where(kind: kind) }
  scope :for_category, -> (category_id) { includes(:categories).where(categories: { id: category_id })}
  scope :for_search_term, -> (term) {
    where("
      unaccent(university_organizations.address) ILIKE unaccent(:term) OR
      unaccent(university_organizations.city) ILIKE unaccent(:term) OR
      unaccent(university_organizations.country) ILIKE unaccent(:term) OR
      unaccent(university_organizations.meta_description) ILIKE unaccent(:term) OR
      unaccent(university_organizations.email) ILIKE unaccent(:term) OR
      unaccent(university_organizations.long_name) ILIKE unaccent(:term) OR
      unaccent(university_organizations.name) ILIKE unaccent(:term) OR
      unaccent(university_organizations.nic) ILIKE unaccent(:term) OR
      unaccent(university_organizations.phone) ILIKE unaccent(:term) OR
      unaccent(university_organizations.siren) ILIKE unaccent(:term) OR
      unaccent(university_organizations.text) ILIKE unaccent(:term) OR
      unaccent(university_organizations.zipcode) ILIKE unaccent(:term) OR
      unaccent(university_organizations.url) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :search_by_siren_or_name, -> (term) {
    where("
      unaccent(university_organizations.siren) ILIKE unaccent(:term) OR
      unaccent(university_organizations.name) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  enum kind: {
    company: 10,
    non_profit: 20,
    government: 30
  }

  def dependencies
    active_storage_blobs +
    blocks
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}organizations/#{slug}.html" if for_website?(website)
  end

  def to_s
    "#{name}"
  end

  protected

  def explicit_blob_ids
    [
      logo&.blob_id,
      logo_on_dark_background&.blob_id
    ]
  end
end
