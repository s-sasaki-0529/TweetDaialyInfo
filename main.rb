require_relative 'src/twitter'
require_relative 'src/zaim'
require_relative 'src/github'

begin
  today    = Date.today
  github   = Github.new('Sa2Knight')
  twitter  = Twitter.new
  zaim     = Zaim.new
  payments = zaim.get_days_amount(today)
  budget   = zaim.get_current_month_private_budget

  twitter.tweet(<<EOL)
#{today.strftime('%Y-%m-%d')}

支出[公費]: #{payments[:public]}円
支出[私費]: #{payments[:private]}円
予算[今月]: #{budget}円

ツイート数: #{twitter.tweets_count(today)}
コミット数: #{github.commit_count}

#ketilog
EOL

rescue => e
  twitter.tweet(<<EOL)
  #ketilog バグった
  #{e}
  #{e.backtrace.join("\n")}
EOL
[0,180]
end
