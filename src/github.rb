require 'date'
require 'json'
require 'net/http'

class Github

  @@BASE_URL = "https://api.github.com"

  #
  # Githubのユーザ名と、集計対象の日付を指定して初期化
  #
  def initialize(username, date = Date.today)
    @username = username
    @events   = events_by_date(date)
  end

  #
  # イベントリストに含まれる総コミット数を取得
  #
  def commit_count
    @events.inject(0) {|sum, e| sum + e['payload']['commits'].length}
  end

  private

    #
    # 指定した日付のPushEventを全て取得する
    #
    def events_by_date(date)
      url = "#{@@BASE_URL}/users/#{@username}/events"
      events = get url
      events.select {|e| e['type'] === 'PushEvent' && Date.parse(e['created_at']) == date}
    end

    #
    # 指定したURLにGETリクエストを送信する
    #
    def get(url)
      uri = URI.parse(url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      req = Net::HTTP::Get.new(uri.request_uri)
      res = https.request(req)
      JSON.parse(res.body)
    end

end
