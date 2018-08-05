require 'date'
require 'uri'
require 'json'

class Util

  KEYSFILE = "keys.json"

  #
  # keys.jsonの内容を取得
  #
  def self.get_api_key
    File.open(KEYSFILE) do |f|
      JSON.load(f)
    end
  end

  #
  # ZaimAPIキーを取得
  #
  def self.get_zaim_api_key
    keys = self.get_api_key
    keys['zaim']
  end

  #
  # TwitterAPIキーを取得
  #
  def self.get_twitter_api_key
    keys = self.get_api_key
    keys['twitter']
  end

  #
  # GithubAPIキーを取得
  #
  def self.get_github_api_key
    self.get_api_key['github']
  end

  #
  # GET用のURLを生成する
  #
  def self.make_url(url , params)
    params.each do |k , v|
      if url.index('?').nil?
        url += "?#{k}=#{v}"
      else
        url += "&#{k}=#{v}"
      end
    end
    url_escape = URI.escape(url)
    return url_escape
  end

  #
  # 日時文字列を日付データに変換する
  # 日時には9時間の時差が含まれていることを前提とする
  #
  def self.str_to_date(date)
    DateTime.parse(date).new_offset(Rational(9, 24)).to_date
  end

  #
  # 指定した日付の、月に対する日数の割合を戻す
  # ex: date = 9/15の場合、30日中の半分が終わっているので0.5を戻す
  #
  def self.days_rate_by(date:)
    days = Date.new(date.year, date.month, -1).day
    day  = date.day
    day.to_f / days.to_f
  end

end
