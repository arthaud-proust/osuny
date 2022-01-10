# == Schema Information
#
# Table name: university_people
#
#  id                :uuid             not null, primary key
#  email             :string
#  first_name        :string
#  is_administration :boolean
#  is_author         :boolean
#  is_researcher     :boolean
#  is_teacher        :boolean
#  last_name         :string
#  phone             :string
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  university_id     :uuid             not null
#  user_id           :uuid
#
# Indexes
#
#  index_university_people_on_university_id  (university_id)
#  index_university_people_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (user_id => users.id)
#
class University::Person::Administrator < University::Person
  def self.polymorphic_name
    'University::Person::Administrator'
  end

  def git_path(website)
    "content/administrators/#{slug}/_index.html" if for_website?(website)
  end

  def for_website?(website)
    is_administration && website.about_school? && Education::School::Administrator.where(school_id: website.about_id, person_id: id).any?
  end
end
