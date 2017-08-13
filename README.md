# jobcan_shift
making shift_reminder on slack from jobcan 

## ■準備
### インストール

```
$ git clone git@github.com:yoshixj/jobcan_shift.git
```

### gem インストール

```
$ cd jobcan-shift
$ bundle install --path vendor/bundle
```

 ※ jobcan-kintaiディレクトリ配下vendor/bundleディレクトリ内にインストールされる。

### 環境変数ファイル 作成・設定

```
$ vi .env
```

 ① キーボードの **i** を押し、 INSERTモード（書き込み可能モード）に変更。

 ② 以下枠内をコピペし、任意の文字列を設定。

```
CLIENT_ID="会社ID"
EMAIL="メールアドレスまたはスタッフコード"
PASS="パスワード"
```

 ③ キーボードの **esc** を押し、続けて **:wq** と入力し完了。

## ■アプリ 設定・実行

### メンバー登録

```
member = {"user1" => "@user1","user2" => "@user2", "user3" => "@user3", "user4" => "@user4"}
```
このハッシュを

```
jobcan登録名　=> "slackの名前"
```

に書き換える

### テキスト登録

```
txt = "/remind #チャンネル名 #{months[month]} #{day-1} at 5pm #{day} 日のシフトお願いします！ "
```

この部分を出力したい文字列に書き換える。

出力例(8月2日のシフトを8月1日17時にリマインドするテキスト出力)
``` /remind #general August 1 at 5pm 2 日のシフトお願いします！ @user1 15-22    @user2 15-22
```

### アプリの実行


```
$ bundle exec ruby main.rb
```


<br>
以上。
