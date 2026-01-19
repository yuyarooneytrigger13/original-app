## usersテーブル
| columm            | type      | options
| ------------------| --------- | ---------
| nickname          | string    | true
| email             | string    | null: false, unique:true
| encrypted_pa​​ssword| string    | null: false



## Association
  has_many :availabilities
  has_many :plans
  has_many :visited_records
  has_many :plan_users


## plansテーブル（旅行計画）

| columm               | type       | options
| -------------------  | ---------  | ---------
| title                | string     | null: false
| status               | text       | null: false
| confirmed_date       | integer    | true
| user                 | references | null: false,foreign_key: true

## Association
  has_many :destinations
  has_many :availabilities
  has_many :candidates
  has_many :schedules
  belongs_to :user

## availabilitiesテーブル（旅行可能日、日程回答）
| columm               | type       | options
| -------------------  | ---------  | ---------
| user_id              | references | null: false,foreign_key: true
| status               | integer    | null: false
| candidate_id         | references | null: false,foreign_key: true

## Association
  belongs_to :candidate
  belongs_to :user
  
## candidatesテーブル（候補日）
| columm               | type       | options
| -------------------  | ---------  | ---------
| date                 | integer    | null: false
| plan_id              | references | null: false,foreign_key: true

## Association
  belongs_to :plan
  has_many   :availabilities

## destinationsテーブル（行先候補）
| columm              | type       | options
| ------------------- | ---------- | ---------
| name                | string     | null: false 
| description         | text       | null: false
| likes_count         | integer    | default: 0, nullfalse
| user_id             | references | null: false,foreign_key: true
| plan_id             | references | null: false,foreign_key: true

## Association
  belongs_to :plan
  has_one_attached :image
  belongs_to :user

## scheduleテーブル（タイムスケジュール）
| columm              | type       | options
| ------------------- | ---------- | ---------
| title               | string     | null: false
| start_time          | datetime   | null: false
| memo                | string     | null: false
| plan_id             | references | null: false,foreign_key: true

## Association
  belongs_to :plan

## visited_recordsテーブル（訪問記録）
| columm              | type       | options
| ------------------- | ---------- | ---------
| user_id             | references | null: false,foreign_key: true
| prefecture          | integer    | null: false,foreign_key: true
| visited_date        | date       | null: false
| review              | string     | null: false

## Association
  belongs_to :user
  has_one_attached :image

## plan_usersテーブル
| columm              | type       | options
| ------------------- | ---------- | ---------
| user                | references | null: false,foreign_key: true
| plan                | references | null: false,foreign_key: true

## Association
  belongs_to :plan
  belongs_to :user
