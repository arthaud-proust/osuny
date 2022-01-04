# == Schema Information
#
# Table name: communication_website_pages
#
#  id                       :uuid             not null, primary key
#  about_type               :string
#  description              :text
#  featured_image_alt       :string
#  github_path              :text
#  old_text                 :text
#  path                     :text
#  position                 :integer          default(0), not null
#  published                :boolean          default(FALSE)
#  slug                     :string
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid
#  communication_website_id :uuid             not null
#  parent_id                :uuid
#  related_category_id      :uuid
#  university_id            :uuid             not null
#
# Indexes
#
#  index_communication_website_pages_on_about                     (about_type,about_id)
#  index_communication_website_pages_on_communication_website_id  (communication_website_id)
#  index_communication_website_pages_on_parent_id                 (parent_id)
#  index_communication_website_pages_on_related_category_id       (related_category_id)
#  index_communication_website_pages_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (communication_website_id => communication_websites.id)
#  fk_rails_...  (parent_id => communication_website_pages.id)
#  fk_rails_...  (related_category_id => communication_website_categories.id)
#  fk_rails_...  (university_id => universities.id)
#

class Communication::Website::Page < ApplicationRecord
  include WithGit
  include WithMedia
  include WithMenuItemTarget
  include WithSlug # We override slug_unavailable? method
  include WithTree

  has_rich_text :text
  has_one_attached_deletable :featured_image

  belongs_to :university
  belongs_to :website,
             foreign_key: :communication_website_id
  belongs_to :related_category,
             class_name: 'Communication::Website::Category',
             optional: true
  belongs_to :parent,
             class_name: 'Communication::Website::Page',
             optional: true
  has_one    :imported_page,
             class_name: 'Communication::Website::Imported::Page',
             dependent: :nullify
  has_many   :children,
             class_name: 'Communication::Website::Page',
             foreign_key: :parent_id,
             dependent: :destroy

  validates :title, presence: true

  after_save :update_children_paths, if: :saved_change_to_path?

  scope :ordered, -> { order(:position) }
  scope :recent, -> { order(updated_at: :desc).limit(5) }

  def git_path_static
    "content/pages/#{path}/_index.html".gsub(/\/+/, '/')
  end

  def git_dependencies_static
    descendents + siblings
  end

  def list_of_other_pages
    website.list_of_pages.reject! { |p| p[:id] == id }
  end

  def to_s
    "#{ title }"
  end

  def best_featured_image(fallback: true)
    return featured_image if featured_image.attached?
    best_image = parent&.best_featured_image(fallback: false)
    best_image ||= featured_image if fallback
    best_image
  end

  def update_children_paths
    children.each do |child|
      child.update_column :path, child.generated_path
      child.update_children_paths
    end
  end

  protected

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(communication_website_id: self.communication_website_id, slug: slug)
              .where.not(id: self.id)
              .exists?
  end
end
