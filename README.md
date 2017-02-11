# 本日の支出額をツイートするCUIツール

## 前提

- TwitterAPIのアクセストークンを取得済み
- ZaimAPIのアクセストークンを取得済み
- Ruby/gemsが使える環境

## インストール方法

1. git clone git@github.com:Sa2Knight/TweetPaidInfo.git
2. cd TweetPaidInfo
3. bundle install --path bundle/vendor
4. keys.json(アクセストークンなどを記載したファイル)を配置

## 実行方法

```
bundle exec ruby main.rb
```

## 実行結果

「本日の支出は680円です」などのツイートが投稿される
