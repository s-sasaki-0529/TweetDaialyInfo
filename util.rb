require 'date'
require 'uri'
require 'json'

class Util

  KEYSFILE = "keys.json"

  # APIキーを取得
  def self.get_api_key
    File.open(KEYSFILE) do |f|
      keys = JSON.load(f)
    end
  end

  # ZaimAPIキーを取得
  def self.get_zaim_api_key
    keys = self.get_api_key
    keys['zaim']
  end

  # TwitterAPIキーを取得
  def self.get_twitter_api_key
    keys = self.get_api_key
    keys['twitter']
  end

end
