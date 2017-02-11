require 'date'
require 'uri'
require 'json'

class Util

  KEYSFILE = "keys.json"

  # APIキーを取得
  # {:key => hoge , :secret => fuga}
  #--------------------------------------------------------------------
  def self.get_api_key()
    File.open(KEYSFILE) do |f|
      keys = JSON.load(f)
      p keys
    end
  end

end
