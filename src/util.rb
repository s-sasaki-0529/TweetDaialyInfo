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

end
