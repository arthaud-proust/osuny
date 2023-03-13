# == Schema Information
#
# Table name: university_organization_categories
#
#  id            :uuid             not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_university_organization_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_f610c7eb13  (university_id => universities.id)
#
require "test_helper"

class University::Organization::CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
