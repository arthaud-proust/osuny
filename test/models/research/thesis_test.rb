# == Schema Information
#
# Table name: research_theses
#
#  id                     :uuid             not null, primary key
#  abstract               :text
#  completed              :boolean          default(FALSE)
#  completed_at           :date
#  started_at             :date
#  title                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  author_id              :uuid             not null
#  director_id            :uuid             not null
#  research_laboratory_id :uuid             not null
#  university_id          :uuid             not null
#
# Indexes
#
#  index_research_theses_on_author_id               (author_id)
#  index_research_theses_on_director_id             (director_id)
#  index_research_theses_on_research_laboratory_id  (research_laboratory_id)
#  index_research_theses_on_university_id           (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => university_people.id)
#  fk_rails_...  (director_id => university_people.id)
#  fk_rails_...  (research_laboratory_id => research_laboratories.id)
#  fk_rails_...  (university_id => universities.id)
#
require "test_helper"

class Research::ThesisTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end