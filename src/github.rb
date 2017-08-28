require 'date'
require 'json'
require 'net/http'

class Github

  @@BASE_URL = "https://api.github.com"

  def initialize(username, date = Date.today)
    @username = username
    @events   = events_by_date(date)
  end

  def commit_count
    @events.inject(0) {|sum, e| sum + e['payload']['commits'].length}
  end

  private

    def events_by_date(date)
      url = "#{@@BASE_URL}/users/#{@username}/events"
      events = get url
      events.select {|e| e['type'] === 'PushEvent' && Date.parse(e['created_at']) == date}
    end

    def get(url)
      uri = URI.parse(url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      req = Net::HTTP::Get.new(uri.request_uri)
      res = https.request(req)
      JSON.parse(res.body)
    end

end
