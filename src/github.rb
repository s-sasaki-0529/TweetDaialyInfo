require 'date'
require 'json'
require 'net/http'

class Github

  @@BASE_URL = "https://api.github.com"

  def initialize(username)
    @username = username
  end

  def events_by_date(date)
    url = "#{@@BASE_URL}/users/#{@username}/events"
    events = get url
    events.select {|e| Date.parse(e['created_at']) == date}
  end

  private

  def get(url)
    uri = URI.parse(url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    res = https.request(req)
    JSON.parse(res.body)
  end

end
