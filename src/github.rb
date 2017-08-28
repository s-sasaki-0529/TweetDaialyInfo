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
      events.select do |e|
        e['created_at'] = DateTime.parse(e['created_at']).new_offset(Rational(9, 24))
        e['type'] === 'PushEvent' && e['created_at'].to_date == date
      end
    end

    #
    # 指定したコミットの変更行数を取得
    # 変更行数は、追加行数 - 削除行数で求める
    #
    def added_lines(repository, commit_hash)
      url = "#{@@BASE_URL}/repos/#{repository}/commits/#{commit_hash}"
      commit = get url
      commit['files'].inject(0) {|sum, f| sum + (f['additions'] - f['deletions']) }
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
