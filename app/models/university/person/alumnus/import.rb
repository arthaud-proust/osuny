# == Schema Information
#
# Table name: university_person_alumnus_imports
#
#  id            :uuid             not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#  user_id       :uuid             not null, indexed
#
# Indexes
#
#  index_university_person_alumnus_imports_on_university_id  (university_id)
#  index_university_person_alumnus_imports_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_3ff74ac195  (user_id => users.id)
#  fk_rails_d14eb003f9  (university_id => universities.id)
#
class University::Person::Alumnus::Import < ApplicationRecord
  include WithUniversity
  include Importable

  def self.table_name
    'university_person_alumnus_imports'
  end

  protected

  def parse
    csv.each do |row|
      program_id = row['program']
      if Rails.env.development? &&
        # substitute local data for testing
        substitutes = {
          'c6b78fac-0a5f-4c44-ad22-4ee68ed382bb' => '23279cab-8bc1-4c75-bcd8-1fccaa03ad55'
        }
        program_id = substitutes[program_id] if substitutes.has_key? program_id
      end
      program = university.education_programs
                          .find_by(id: program_id)
      next if program.nil?
      academic_year = university.academic_years
                                .where(year: row['year'])
                                .first_or_create

      cohort = university.education_cohorts
                         .where(program: program, academic_year: academic_year)
                         .first_or_create
      first_name = clean_encoding row['first_name']
      last_name = clean_encoding row['last_name']
      email = clean_encoding(row['mail']).to_s.downcase
      next if first_name.blank? && last_name.blank? && email.blank?
      url = clean_encoding row['url']
      if email.present?
        person = university.people
                           .where(email: email)
                           .first_or_create
        person.first_name = first_name
        person.last_name = last_name
      else
        person = university.people
                           .where(first_name: first_name, last_name: last_name)
                           .first_or_create
      end
      # TODO all fields
      # gender
      # birth
      # address
      # zipcode
      # city
      # country
      person.is_alumnus = true
      person.url = url
      person.slug = person.to_s.parameterize.dasherize
      person.twitter ||= row['social_twitter']
      person.linkedin ||= row['social_linkedin']
      person.biography ||= row['biography']
      person.phone ||= row['mobile']
      person.phone ||= row['phone_personal']
      person.phone ||= row['phone_professional']
      byebug unless person.valid?
      person.save
      cohort.people << person unless person.in?(cohort.people)
      add_picture person, row['photo']

      company_name = clean_encoding row['company_name']
      company_siren = clean_encoding row['company_siren']
      company_nic = clean_encoding row['company_nic']
      if company_name.present?
        if !row['company_siren'].blank? && !row['company_nic'].blank?
          organization = university.organizations
                                   .find_by siren: company_siren,
                                            nic: company_nic
        elsif !row['company_siren'].blank?
          organization ||= university.organizations
                                   .find_by siren: company_siren
        end
        if !company_name.blank?
          organization ||= university.organizations
                                     .find_by name: company_name
        end
        organization ||= university.organizations
                                   .where( name: company_name,
                                           siren: company_siren,
                                           nic: company_nic)
                                   .first_or_create
        experience_job = row['experience_job']
        experience_from = row['experience_from']
        experience_to = row['experience_to']
        experience = person.experiences
                           .where(university: university,
                                  organization: organization,
                                  description: experience_job)
                           .first_or_create
        experience.from_year = experience_from
        experience.to_year = experience_to
        experience.save
      end
    end
  end

  def add_picture(person, photo)
    return if photo.nil?
    return if person.picture.attached?
    return unless photo.end_with?('.jpg') || photo.end_with?('.png')
    begin
      file = URI.open photo
      filename = File.basename photo
      person.picture.attach(io: file, filename: filename)
    rescue
    end
  end

  def clean_encoding(value)
    return if value.nil?
    if value.encoding != 'UTF-8'
      value = value.force_encoding 'UTF-8'
    end
    value.strip
  end
end
