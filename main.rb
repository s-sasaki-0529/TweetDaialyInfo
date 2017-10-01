require_relative 'src/twitter'
require_relative 'src/zaim'
require_relative 'src/github'

begin
  today   = Date.today
  github  = Github.new('Sa2Knight')
  twitter = Twitter.new
  amounts = Zaim.new.get_days_amount(today)

  twitter.tweet(<<EOL)
  #{today.strftime('%Y-%m-%d')}

  【Zaim】
  公費:     #{amounts[:public]}円
  私費:     #{amounts[:private]}円

  【Twitter】
  ツイート数: #{twitter.tweets_count(today)}

  【Github】
  コミット数: #{github.commit_count}
  追加行数:   #{github.total_added_lines}行

  #ketilog
EOL
rescue => e
  Twitter.new.tweet(<<EOL)
  #ketilog がバグりました

  #{e}
EOL
end
