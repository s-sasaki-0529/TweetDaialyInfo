require 'json'
require 'pp'
require_relative "util"
class Zaim

  MONTHLY_BUDGET  = 60000
  API_URL = 'https://api.zaim.net/v2/'

  #
  # 初期化時にZaimAPIの利用準備を行う
  #
  def initialize(date)
    api_key = Util.get_zaim_api_key
    oauth_params = {
      site: "https://api.zaim.net",
      request_token_path: "/v2/auth/request",
      authorize_url: "https://auth.zaim.net/users/auth",
      access_token_path: "https://api.zaim.net"
    }
    @consumer = OAuth::Consumer.new(api_key["key"], api_key["secret"], oauth_params)
    @access_token = OAuth::AccessToken.new(@consumer, api_key["access_token"], api_key["access_token_secret"])
    @date = date
    @payments_cach = {}
  end

  #
  # 指定した日付の私費/公費の和をそれぞれ戻す
  # 公費とも私費とも取れない支払いがあった場合に例外を吐く
  #
  def get_days_amount(params = {})
    payments = get_days_payments(@date, params)
    private_payments = payments.select{|payment| payment['comment'] =~ /私費/}
    public_payments  = payments.select{|payment| payment['comment'] =~ /公費/}
    unless (payments - private_payments - public_payments).empty?
      raise '公費でも私費でもない支払いがzaimに登録されてるよ！'
    end
    public_amounts = public_payments.inject(0) {|sum, n| sum + n['amount'] }
    private_amounts = private_payments.inject(0) {|sum, n| sum + n['amount'] }
    return {
      public: public_amounts,
      private: private_amounts
    }
  end

  #
  # 今月の残りお小遣い額を取得
  #
  def get_current_month_private_budget
    payments = get_month_payments(@date.year, @date.month).select {|payment| payment['comment'] =~ /私費/}
    total_amount = payments.inject(0) {|sum, n| sum + n['amount']}
    return MONTHLY_BUDGET - total_amount
  end

  private

    #
    # 指定した日付の支出一覧を取得
    #
    def get_days_payments(date, params = {})
      date = date.strftime('%Y-%m-%d')
      get_payments({
        start_date: date,
        end_date:   date
      })
    end

    #
    # 指定した月の支出一覧を取得
    #
    def get_month_payments(year, month, params = {})
      get_payments({
        start_date: Date.new(year, month),
        end_date:   Date.new(year, month, -1)
      })
    end

    #
    # 支出一覧を取得
    # 同パラメータの場合はキャッシュを用いる
    #
    def get_payments(params)
      cach_key = params.to_s
      return @payments_cach[cach_key] if @payments_cach[cach_key]

      params.merge!({
        'mode': 'payment'
      })
      url = Util.make_url("home/money" , params)
      @payments_cach[cach_key] = get(url)['money']
    end

    #
    # ZaimAPIに対してPOSTリクエストを送信
    #
    def get(url)
      response = @access_token.get("#{API_URL}#{url}")
      JSON.parse(response.body)
    end

end
