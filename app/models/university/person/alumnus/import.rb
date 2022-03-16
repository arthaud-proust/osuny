class University::Person::Alumnus::Import < ApplicationRecord
  include WithUniversity

  belongs_to :user

  has_one_attached :file

  after_save :parse

  def self.table_name
    'university_person_alumnus_imports'
  end

  def lines
    csv.count
  rescue
    'NA'
  end

  def to_s
    "#{user}, #{I18n.l created_at}"
  end

  protected

  def parse
  end
end
