require 'twitter_oauth'
require_relative 'util'
class Twitter

  attr_reader :authed

  #
  # 初期化時にTwitterAPIの利用準備
  #
  def initialize

    twitter_api = Util.get_twitter_api_key
    key = twitter_api['key']
    secret = twitter_api['secret']
    a_token = twitter_api['access_token']
    a_secret = twitter_api['access_token_secret']

    @twitter = TwitterOAuth::Client.new(
      :consumer_key => key,
      :consumer_secret => secret,
      :token => a_token,
      :secret => a_secret
    )
    @authed = @twitter && @twitter.info['screen_name'] ? true : false
  end

  #
  # 指定した日のツイート数を取得
  #
  def tweets_count(date)
    params = {
      screen_name: @twitter.info['screen_name'],
      count:           200,
      trim_user:       true,
      exclude_replies: false,
      include_rts:     false,
    }
    tweets = @twitter.user_timeline(params).select {|t| Util.str_to_date(t['created_at']) == date}
    tweets.count
  end

  #
  # 指定したテキストを含む直近のツイートを取得
  #
  def search_last_tweet_by_text(user_screen_name, text, opt = {})
    params = {
      screen_name: user_screen_name,
      count: 200,
      tweet_mode: :extended,
    }.merge(opt)
    tweets = @twitter.user_timeline(params)
    tweet  = tweets.select {|t| t['full_text'].index(text)}.first
    if tweet.nil?
      sleep 1
      tweet = search_last_tweet_by_text(user_screen_name, text, max_id: tweets[-1]['id_str'])
    end
    return tweet
  end

  #
  # 指定したテキストをツイートする
  #
  def tweet(text)
    @twitter.update(text)
  end

end
