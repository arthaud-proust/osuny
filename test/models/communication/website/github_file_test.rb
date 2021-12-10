# == Schema Information
#
# Table name: communication_website_github_files
#
#  id                  :uuid             not null, primary key
#  about_type          :string           not null
#  github_path         :string
#  manifest_identifier :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  about_id            :uuid             not null
#  website_id          :uuid             not null
#
# Indexes
#
#  index_communication_website_github_files_on_about       (about_type,about_id)
#  index_communication_website_github_files_on_website_id  (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (website_id => communication_websites.id)
#
require "test_helper"

class Communication::Website::GithubFileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end