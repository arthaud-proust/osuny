# == Schema Information
#
# Table name: university_roles
#
#  id            :uuid             not null, primary key
#  description   :text
#  position      :integer
#  target_type   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  target_id     :uuid
#  university_id :uuid             not null
#
# Indexes
#
#  index_university_roles_on_target         (target_type,target_id)
#  index_university_roles_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
require "test_helper"

class University::RoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end