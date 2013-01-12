require 'net/https'
require 'uri'
require 'json'

class SlcResource
  # hardcode some paths for resources we can use in our quick prototype
  STUDENTS_URI = '/sections/88c701d291e11e2d17b9554412878cc9bc7d51e6_id/studentSectionAssociations/students'

  def self.fetch_resource(uri, token)
    clean_uri = uri.sub(/^\//, '')

    uri = URI.parse("#{Rails.application.config.REST_URL}/#{clean_uri}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    request.add_field("Content-Type", "application/vnd.slc+json")
    request.add_field("Accept", "application/vnd.slc+json")
    request.add_field("Authorization", "bearer #{token}")

    response = http.request(request)
    JSON.parse(response.body)
  end


  # parent and/or teacher logs in --> magic --> obtain students
  def self.fetch_students(token)

    # path for a specific set of students

    fetch_resource(STUDENTS_URI, token)
  end
end