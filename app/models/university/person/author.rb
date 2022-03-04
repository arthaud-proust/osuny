# == Schema Information
#
# Table name: university_people
#
#  id                :uuid             not null, primary key
#  biography         :text
#  description       :text
#  email             :string
#  first_name        :string
#  habilitation      :boolean          default(FALSE)
#  is_administration :boolean
#  is_researcher     :boolean
#  is_teacher        :boolean
#  last_name         :string
#  phone             :string
#  slug              :string
#  tenure            :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  university_id     :uuid             not null, indexed
#  user_id           :uuid             indexed
#
# Indexes
#
#  index_university_people_on_university_id  (university_id)
#  index_university_people_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_433744b4e8  (user_id => users.id)
#  fk_rails_49ac392937  (university_id => universities.id)
#
class University::Person::Author < University::Person
  def self.polymorphic_name
    'University::Person::Author'
  end

  def git_path(website)
    "content/authors/#{slug}/_index.html" if for_website?(website)
  end

  def for_website?(website)
    communication_website_posts.published
                              .where(communication_website_id: website&.id)
                              .any?
  end
end
