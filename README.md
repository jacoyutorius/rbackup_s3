rbackup_s3
==========

Backup tool for Amazon S3 written in Ruby. This will back up the files to each generation.



## 必要なもの

* ruby2.0 ~ 
* AWSアカウント、S3のバケットへアクセス権のあるユーザーのアクセスキー・シークレットキー


## 設定

* setting.yml


``` yaml

AWS_ACCESS_KEY_ID:  # AWSのアクセスキー
AWS_SECRET_ACCESS_KEY: # AWSのシークレットアクセスキー
AWS_REGION: ap-northeast-1
BUCKET_NAME:  # S3の対象バケット名
SAVE_PERIOD: 3 # ファイルの保存期間(日)

```


## 使い方

```ruby
ruby bin/rbs3 sample.txt backup.zip
```

