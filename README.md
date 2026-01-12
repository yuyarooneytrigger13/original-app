## usersテーブル
| columm            | type      | options
| ------------------| --------- | ---------
| nickname          | string    | null: false
| email             | string    | null: false, unique:true
| encrypted_pa​​ssword| string    | null: false



## Association
  has_many :availabilities
  has_many :destinations
  has_many :plans
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
  has_many :candidates
  has_many :schedules



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
| user_id             | references | null: false,foreign_key: true
| plan_id             | references | null: false,foreign_key: true

## Association
  belongs_to :plan
  has_many   :votes
  has_many   :schedules

## scheduleテーブル（タイムスケジュール）
| columm              | type       | options
| ------------------- | ---------- | ---------
| title          | string | null: false
| start_time      | datetime | null: false
| memo               | string    | null: false
| plan_id    | references | null: false,foreign_key: true


## visited_recordsテーブル（訪問記録）
| columm              | type       | options
| ------------------- | ---------- | ---------
| user_id             | references | null: false,foreign_key: true
| prefecture_id       | references | null: false,foreign_key: true
| visited_date        | date       | null: false
| review              | string     | null: false
