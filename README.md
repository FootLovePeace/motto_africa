# Motto Africa

## ユーザー登録すると、アフリカ大陸の全ての国について様々なジャンルで自由に記事を投稿したり、記事に対してコメントすることができます。
## また、ログイン状態に関わらず、ユーザーは自由に記事を閲覧したり、「国名」と「ジャンル」を組み合わせて、記事を検索することもできます。
<br>

# URL
<br>

# テスト用アカウント
<br>

# 制作背景
### 昔アフリカでボランティア活動をしたことがありましたが、それまでは「アフリカ＝未知数」というイメージでした。しかし、実際に現地で生活してみると良い意味でイメージが覆されることが沢山あり、現地での活動を通してアフリカが身近に感じられるようになりました。
### この経験から、もっとアフリカについて知ることができれば、アフリカについての関心や興味も湧いて身近なものになると思いました。
### そこで、アフリカが好きな人や興味はあるけどイメージがわかない人にとって、「もっとアフリカを身近に感じることができる」をコンセプトにした、アフリカの各国の様々な情報がまとまっている投稿サイトを制作しようと思いました。
<br>

# 要件定義
# DEMO
# 実装予定の内容 
<br>

# テーブル設計

## users テーブル

| Column             | Type     | Options     |
| ------------------ | -------- | ----------- |
| nickname           | string   | null: false |
| email              | string   | null: false |
| encrypted_password | string   | null: false |

### Association

- has_many :posts
- has_many :comments

## posts テーブル

| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| title      | string     | null: false                    |
| text       | text       | null: false                    |
| country_id | integer    | null: false                    |
| genre_id   | integer    | null: false                    |
| user       | references | null: false, foreign_key: true |

### Association

- has_many :comments
- beloｎgs_to :user

## comments テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| title  | text       | null: false                    |
| user   | references | null: false, foreign_key: true |
| post   | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :post