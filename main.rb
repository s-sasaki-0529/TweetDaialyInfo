require_relative 'src/twitter'
require_relative 'src/zaim'
require_relative 'src/github'

today = Date.today

amounts = Zaim.new.get_days_amount(today)

github  = Github.new('Sa2Knight')
commits = github.commit_count
lines   = github.total_added_lines

Twitter.new.tweet(<<EOL)
@null

#{today.strftime('%Y-%m-%d')}

【支出額】
#{amounts}円

【Github】
#{commits}コミット
計#{lines}行追加

#ketilog
EOL
