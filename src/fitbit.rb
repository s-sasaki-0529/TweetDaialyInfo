require 'date'
require 'json'
require 'net/http'

class Fitbit
  BASE_URL       = 'https://api.fitbit.com/1/user/-'
  ACCESS_TOKEN   = ENV['FITBIT_ACCESS_TOKEN']
  REQUEST_HEADER = { 'Authorization' => "Bearer #{ACCESS_TOKEN}" }

  def fetch_steps_by_date(date)
    url = "#{BASE_URL}/activities/date/#{date}.json"
    activities = get(url)
    activities['summary']['steps']
  end

  private

    def get(url)
      uri = URI.parse(url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      req = Net::HTTP::Get.new(uri.request_uri, REQUEST_HEADER)
      res = https.request(req)
      JSON.parse(res.body)
    end

end
