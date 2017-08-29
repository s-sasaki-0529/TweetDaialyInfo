require_relative 'src/twitter'
require_relative 'src/zaim'
require_relative 'src/github'

today   = Date.today
zaim    = Zaim.new
twitter = Twitter.new
github  = Github.new('Sa2Knight')

Twitter.new.tweet(<<EOL)
#{today.strftime('%Y-%m-%d')}

【Zaim】
支出額:     #{zaim.get_days_amount(today)}円

【Twitter】
ツイート数: #{twitter.tweets_count(today)}

【Github】
コミット数: #{github.commit_count}
追加行数:   #{github.total_added_lines}行

#ketilog
EOL
