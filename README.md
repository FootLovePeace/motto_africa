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

## posｔs テーブル

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