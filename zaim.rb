require 'oauth'
require 'json'
require 'pp'
require_relative "util"
class Zaim

  API_URL = 'https://api.zaim.net/v2/'

  # ZaimAPIへのアクセストークンを生成する
  def initialize
    api_key = Util.get_zaim_api_key
    oauth_params = {
      site: "https://api.zaim.net",
      request_token_path: "/v2/auth/request",
      authorize_url: "https://auth.zaim.net/users/auth",
      access_token_path: "https://api.zaim.net"
    }
    @consumer = OAuth::Consumer.new(api_key["key"], api_key["secret"], oauth_params)
    @access_token = OAuth::AccessToken.new(@consumer, api_key["access_token"], api_key["access_token_secret"])
  end

  # 指定した日付の総支出額を戻す
  def get_days_amount(date , params = {})
    params["mode"] = "payment"
    params["start_date"] = date
    params["end_date"] = date
    url = Util.make_url("home/money" , params)
    get(url)["money"].inject(0) {|sum , n| sum + n["amount"]}
  end

  # ZaimAPIに対してPOSTリクエストを送信する
  def get(url)
    response = @access_token.get("#{API_URL}#{url}")
    JSON.parse(response.body)
  end

  # ZaimAPIに対してPUTリクエストを送信する
  def put(url , params = nil)
    response = @access_token.put("#{API_URL}#{url}" , params)
    JSON.parse(response.body)
  end

end
