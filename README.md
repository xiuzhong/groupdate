# Groupdate2
groupdate2 is an enhanced version of the beautiful [Groupdate](https://github.com/ankane/groupdate) gem.
It adds MS SQL Server (2016 and above) support by using `(AT TIME ZONE)`.

In JRuby, it relies on `activerecord-sqlserver-adapter` `jdbc-mode` branch, which is not ideal. The plan is using `activerecord-jdbcsqlserver-adapter` when JRuby 9.2+ is supported.

# Version
## 4.1.3
This version corresponds to groupdate 4.1.2 with SQL Server support.

## Installation
Add this line to your application’s Gemfile:
```ruby
gem 'groupdate2'
```

