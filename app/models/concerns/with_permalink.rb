module WithPermalink
  extend ActiveSupport::Concern

  included do
    has_many  :permalinks,
              class_name: "Communication::Website::Permalink",
              as: :about,
              dependent: :destroy
  end

  # Persisted in db
  def current_permalink_in_website(website)
    permalinks.for_website(website).current.first
  end

  # Not persisted yet
  def new_permalink_in_website(website)
    Communication::Website::Permalink.for_object(self, website)
  end

  # Called from git_file.sync
  def manage_permalink_in_website(website)
    current_permalink = current_permalink_in_website(website)
    new_permalink = new_permalink_in_website(website)

    # If the object had no permalink or if its path changed, we create a new permalink
    if new_permalink.computed_path.present? && (current_permalink.nil? || current_permalink.path != new_permalink.computed_path)
      new_permalink.path = new_permalink.computed_path
      current_permalink&.update(is_current: false) if new_permalink.save
    end
  end

end
