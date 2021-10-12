# == Schema Information
#
# Table name: languages
#
#  id         :uuid             not null, primary key
#  iso_code   :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Language < ApplicationRecord

  has_many :users

  validates_presence_of :iso_code
  validates_uniqueness_of :iso_code

  default_scope { order(name: :asc) }

  def to_s
    "#{name}"
  end
end
