require 'optparse'
require_relative 'src/twitter'
require_relative 'src/zaim'
require_relative 'src/dmm'
require_relative 'src/fitbit'
require_relative 'src/touch_on_time'

# 例外発生時にリトライ用カウント
try_cnt = 0

begin

  try_cnt += 1

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
  since_hair_cut    = zaim.get_days_since_hair_cut

  # DMM残容量をスクレイピング
  dmm      = Dmm.new

  # TouchOnTimeで残業時間をスクレイピング
  touch_on_time = TouchOnTime.new(today)

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

勤務[本日]: #{touch_on_time.days_working_time_str}
残業[本日]: #{touch_on_time.days_over_time_str}
残業[今月]: #{touch_on_time.total_over_time_str}

コンタクト: #{contact}日目
散髪から: #{since_hair_cut}日目
スマホ残容量: #{dmm.remaing_capacity ? dmm.remaing_rate + '%' : '取得失敗'}
スマホ残目安: #{dmm.remaing_capacity ? dmm.remaing_rate_indication + '%' : '取得失敗'}

#ketilog
EOL

  # ツイートまたは標準出力
  if is_stdout
    puts tweet_text
  else
    twitter.tweet(tweet_text)
  end

rescue => e
  retry if try_cnt < 3
  p e
  err_tweet = <<EOL
  #ketilog バグった
  #{e}
  #{e.backtrace.join("\n")}
EOL
  p err_tweet
  Twitter.new.tweet(err_tweet[0, 160])
end
