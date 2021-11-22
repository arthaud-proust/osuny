# == Schema Information
#
# Table name: communication_website_categories
#
#  id                       :uuid             not null, primary key
#  description              :text
#  github_path              :text
#  is_programs_root         :boolean          default(FALSE)
#  name                     :string
#  position                 :integer
#  slug                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null
#  parent_id                :uuid
#  program_id               :uuid
#  university_id            :uuid             not null
#
# Indexes
#
#  idx_communication_website_post_cats_on_communication_website_id  (communication_website_id)
#  index_communication_website_categories_on_parent_id              (parent_id)
#  index_communication_website_categories_on_program_id             (program_id)
#  index_communication_website_categories_on_university_id          (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (communication_website_id => communication_websites.id)
#  fk_rails_...  (parent_id => communication_website_categories.id)
#  fk_rails_...  (program_id => education_programs.id)
#  fk_rails_...  (university_id => universities.id)
#
class Communication::Website::Category < ApplicationRecord
  include WithGithub
  include WithSlug
  include WithTree

  belongs_to :university
  belongs_to :website,
             foreign_key: :communication_website_id
  belongs_to :parent,
            class_name: 'Communication::Website::Category',
            optional: true
  belongs_to :program,
            class_name: 'Education::Program',
            optional: true
  has_one :imported_category,
          class_name: 'Communication::Website::Imported::Category',
          dependent: :destroy
  has_many :children,
           class_name: 'Communication::Website::Category',
           foreign_key: :parent_id,
           dependent: :destroy
  has_and_belongs_to_many :posts,
                          class_name: 'Communication::Website::Post',
                          join_table: 'communication_website_categories_posts',
                          foreign_key: 'communication_website_category_id',
                          association_foreign_key: 'communication_website_post_id'

  validates :name, presence: true
  validates :slug, uniqueness: { scope: :communication_website_id }

  scope :ordered, -> { order(:position) }

  before_create :set_position

  def list_of_other_categories
    categories = []
    website.categories.where.not(id: id).root.ordered.each do |category|
      categories.concat(category.self_and_children(0))
    end
    categories.reject! { |p| p[:id] == id }
    categories
  end

  def to_s
    "#{name}"
  end

  def github_path_generated
    "_categories/#{slug}.html"
  end

  def to_jekyll
    ApplicationController.render(
      template: 'admin/communication/website/categories/jekyll',
      layout: false,
      assigns: { category: self }
    )
  end

  protected

  def set_position
    last_element = website.categories.where(parent_id: parent_id).ordered.last

    unless last_element.nil?
      self.position = last_element.position + 1
    else
      self.position = 1
    end
  end

  def slug_unavailable?(slug)
    self.class.unscoped.where(communication_website_id: self.communication_website_id, slug: slug).where.not(id: self.id).exists?
  end
end
