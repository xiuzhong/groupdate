# Groupdate2
groupdate2 is an enhanced version of the beautiful [Groupdate](https://github.com/ankane/groupdate) gem, it adds following features to Groupdate:

## series_label, an option to include `group clause` in selected result

### User case
If you use groupdate not with ActiveRecord::Calculations, but manually selecting the calculation like:
```sql
sql = "COUNT(*) AS count, AVG(delivery.volume/truck.capacity) AS percentage, MIN(collected_at) AS collected_at"
```
Delivery.select(sql).group_by_day(:collected_at).to_a

It works well except the series label is not included in the result. I have to use MIN(collected_at) to have it, then convert it to the correct label in ruby code. It works but is cumbersome.

With this new option `series_label: collected_at_date`, it indicates the group clause should be included in the result and can be accessed by the method collected_at_date.

### Notes
- !!! This option does NOT work with ActiveRecord::Calculations.
- The series_label respects other Groupdate options like :locale, :dates and :format

[See more options](https://github.com/ankane/groupdate)

### An example
```ruby
users = User.select('COUNT(*) AS total, AVG(age) as average_age').group_by_month(:created_at, series_label: :created_at_month)

#The returned result would have attributes:
users.first.created_at_month
users.first.total
users.first.average_age
```
