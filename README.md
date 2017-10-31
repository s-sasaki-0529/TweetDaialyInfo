# 一日の記録をツイートするCUIツール

## 前提

- 完全に私用ツール
- TwitterAPIのアクセストークンを取得済み
- ZaimAPIのアクセストークンを取得済み
- Ruby/gemsが使える環境

## インストール方法

1. git clone git@github.com:Sa2Knight/TweetPaidInfo.git
2. cd TweetPaidInfo
3. bundle install --path bundle/vendor
4. keys.json(アクセストークンなどを記載したファイル)を配置

## keys.jsonの例

```
{
  "zaim": {
    "key":"hogehoge",
    "secret":"fugafuga",
    "access_token":"foofoo",
    "access_token_secret":"barbar"
  },
  "twitter": {
    "key":"hogehoge",
    "secret":"fugafuga",
    "access_token":"foofoo",
    "access_token_secret":"barbar"
  }
}
```

## 実行方法

```
bundle exec ruby main.rb
```

## 実行結果

こんな感じのツイートが投稿される

![スクリーンショット](https://github.com/Sa2Knight/screenshot/blob/master/tweetdialyinfo.png)

## 運用

24時間稼働してるサーバで、cronを用いて毎日23時55分にmain.rbを実行する
