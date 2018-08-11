require 'optparse'
require_relative 'src/twitter'
require_relative 'src/zaim'
require_relative 'src/dmm'
require_relative 'src/fitbit'
require_relative 'src/touch_on_time'

begin
  # コマンドライン引数解釈
  arguments = ARGV.getopts('d:s')
  date_offset = arguments['d'] ? arguments['d'].to_i : 0
  is_stdout =   arguments['s']

  # スクリプト実行日
  today    = Date.today + date_offset
  dow      = %w(日 月 火 水 木 金 土)[today.wday]

  # ZaimAPI連携
  zaim     = Zaim.new(today)
  payments = zaim.get_days_amount
  budget   = zaim.get_current_month_private_budget
  budget_indication = zaim.get_month_private_budget_indication
  lunch_place       = zaim.get_lunch_place
  since_hair_cut    = zaim.get_days_since_hair_cut

  # DMM残容量をスクレイピング
  dmm      = Dmm.new

  # TouchOnTimeで残業時間をスクレイピング
  touch_on_time = TouchOnTime.new

  # TwitterAPI連携
  twitter  = Twitter.new
  contact  = Twitter.new.get_days_from_tweeted('コンタクト初日') + 1

  # FitbitAPI連携
  fitbit   = Fitbit.new
  # steps    = fitbit.fetch_steps_by_date(today) APIトークンが安定しないため

  # ツイート内容の生成
  tweet_result = tweet_text = <<EOL
#{today.strftime('%Y-%m-%d')}(#{dow})

支出[公費]: #{payments[:public]}円
支出[私費]: #{payments[:private]}円
予算[今月]: #{budget}円
予算[目安]: #{budget_indication}円

昼食: #{lunch_place}
コンタクト: #{contact}日目
散髪から: #{since_hair_cut}日目
スマホ残容量: #{dmm.remaing_rate}%
スマホ残目安: #{dmm.remaing_rate_indication}%
今月残業時間: #{touch_on_time.total_over_time}時間

#ketilog
EOL

  # ツイートまたは標準出力
  if is_stdout
    puts tweet_text
  else
    twitter.tweet(tweet_text[0, 140])
  end

rescue => e
  p e
  err_tweet = <<EOL
  #ketilog バグった
  #{e}
  #{e.backtrace.join("\n")}
EOL
  p err_tweet
  Twitter.new.tweet(err_tweet[0, 140])
end
