## usersテーブル
| columm            | type      | options
| ------------------| --------- | ---------
| nickname          | string    | null: false
| email             | string    | null: false, unique:true
| encrypted_pa​​ssword| string    | null: false



## Association
  has_many :availabilities
  has_many :destinations
  has_many :votes
  has_many :visited_records


## plansテーブル（旅行計画）

| columm               | type       | options
| -------------------  | ---------  | ---------
| title                | string     | null: false
| status               | text       | null: false
| confirmed_date       | integer    | null: false
| destination_id       | references | null: false,foreign_key: true

## Association
  has_many :destinations
  has_many :availabilities


## availabilitiesテーブル（旅行可能日、日程回答）
| columm               | type       | options
| -------------------  | ---------  | ---------
| user_id              | references | null: false,foreign_key: true
| date                 | date       | null: false
| is_available         | boolean    | null: false
| comment              | string     | null: false

## Association
  


## destinationsテーブル（行先候補）
| columm              | type       | options
| ------------------- | ---------- | ---------
| name                | string     | null: false,foreign_key: true
| description         | text       | null: false,foreign_key: true
| user_id             | references | null: false,foreign_key: true
| plan_id             | references | null: false,foreign_key: true


## Association
  belongs_to :plan
  has_many   :votes

## votesテーブル（熱量・評価の投票）
| columm              | type       | options
| ------------------- | ---------- | ---------
| user_id             | references | null: false,foreign_key: true
| destination_id      | references | null: false,foreign_key: true
| score               | integer    | null: false


## visited_recordsテーブル（訪問記録）
| columm              | type       | options
| ------------------- | ---------- | ---------
| user_id             | references | null: false,foreign_key: true
| prefecture_code     | references | null: false,foreign_key: true
| plan_id             | references | null: false,foreign_key: true
| visited_date        | integer    | null: false
| review              | string     | null: false
