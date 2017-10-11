require 'date'
require 'json'
require 'net/http'
require_relative 'util'

class Github

  @@BASE_URL = "https://api.github.com"

  #
  # Githubのユーザ名と、集計対象の日付を指定して初期化
  # GithubAPI用のトークンは環境変数より取得する
  #
  def initialize(username, date = Date.today)
    @token    = Util.get_github_api_key
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
      events.select do |e|
        e['created_at'] = Util.str_to_date(e['created_at'])
        e['type'] === 'PushEvent' && e['repo']['name'].index(@username) && e['created_at'] == date
      end
    end

    #
    # 指定したURLにGETリクエストを送信する
    #
    def get(url)
      uri = URI.parse(url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      uri.query = URI.encode_www_form(access_token: @token)
      req = Net::HTTP::Get.new(uri.request_uri)
      res = https.request(req)
      JSON.parse(res.body)
    end

end
