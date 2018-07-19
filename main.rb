require_relative 'src/twitter'
require_relative 'src/zaim'
require_relative 'src/dmm'

begin
  # スクリプト実行日
  today    = Date.today

  # ZaimAPI連携
  zaim     = Zaim.new(today)
  payments = zaim.get_days_amount
  budget   = zaim.get_current_month_private_budget
  lunch_place    = zaim.get_lunch_place
  since_hair_cut = zaim.get_days_since_hair_cut

  # DMM残容量をスクレイピング
  dmm      = Dmm.new

  # TwitterAPI連携
  twitter  = Twitter.new
  contact  = Twitter.new.get_days_from_tweeted('コンタクト初日') + 1

  # ツイート内容の生成
  tweet_result = tweet_text = <<EOL
#{today.strftime('%Y-%m-%d')}

支出[公費]: #{payments[:public]}円
支出[私費]: #{payments[:private]}円
予算[今月]: #{budget}円

昼食: #{lunch_place}
コンタクト: #{contact}日目
散髪から: #{since_hair_cut}日目
スマホ残容量: #{dmm.remaing_rate}%

#ketilog
EOL

  # ツイートを投稿
  twitter.tweet(tweet_text[0, 140])

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
