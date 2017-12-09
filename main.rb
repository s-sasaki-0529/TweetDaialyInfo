require_relative 'src/twitter'
require_relative 'src/zaim'
require_relative 'src/github'
require_relative 'src/analytics'

begin
  today    = Date.today
  github   = Github.new('Sa2Knight')
  twitter  = Twitter.new
  zaim     = Zaim.new(today)
  payments = zaim.get_days_amount(today)
  budget   = zaim.get_current_month_private_budget
  contact  = Twitter.new.get_days_from_tweeted('コンタクト初日') + 1
  sessions = Analytics.new('158527891').report_sessions_count_by_date(today)

  tweet_text = <<EOL
#{today.strftime('%Y-%m-%d')}

[Zaim]
支出[公費]: #{payments[:public]}円
支出[私費]: #{payments[:private]}円
予算[今月]: #{budget}円

[Twitter]
ツイート: #{twitter.tweets_count(today)}
コンタクト: #{contact}日目

[Github]
コミット: #{github.commit_count}

[Analytics]
ブログセッション: #{sessions[:total]}
EOL

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
