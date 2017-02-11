require 'twitter_oauth'
class Twitter

  attr_reader :authed

  # initialize - TwitterAPIアクセス用トークンを生成
  #---------------------------------------------------------------------
  def initialize

    twitter_api = Util.read_secret('twitter_api')
    key = twitter_api['key']
    secret = twitter_api['secret']
    a_token = nil
    a_secret = nil

    if @access_token = Util.read_secret
      a_token = @access_token[:token] || nil
      a_secret = @access_token[:secret] || nil
    end

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
