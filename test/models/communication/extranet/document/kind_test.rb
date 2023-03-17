# == Schema Information
#
# Table name: communication_extranet_document_kinds
#
#  id            :uuid             not null, primary key
#  name          :string
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  extranet_id   :uuid             not null, indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  extranet_document_kinds_universities                        (university_id)
#  index_communication_extranet_document_kinds_on_extranet_id  (extranet_id)
#
# Foreign Keys
#
#  fk_rails_27a9b91ed8  (extranet_id => communication_extranets.id)
#  fk_rails_2a55cf899a  (university_id => universities.id)
#
require "test_helper"

class Communication::Extranet::Document::KindTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end