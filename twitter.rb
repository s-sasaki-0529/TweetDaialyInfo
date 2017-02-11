require 'twitter_oauth'
require_relative 'util'
class Twitter

  attr_reader :authed

  # initialize - TwitterAPIアクセス用トークンを生成
  #---------------------------------------------------------------------
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

  # tweet - ツイートする
  #-------------------------------------------------------------------
  def tweet(text)
    @twitter.update(text)
  end

end
