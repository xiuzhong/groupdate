source "https://rubygems.org"

# Specify your gem's dependencies in groupdate.gemspec
gemspec

gem "activerecord", "~> 6.0.0"

if defined?(JRUBY_VERSION)
  gem "activerecord-jdbcpostgresql-adapter", git: "https://github.com/jruby/activerecord-jdbc-adapter.git", platforms: :jruby
  gem "activerecord-jdbcmysql-adapter", git: "https://github.com/jruby/activerecord-jdbc-adapter.git", platforms: :jruby
  gem "activerecord-jdbcsqlite3-adapter", git: "https://github.com/jruby/activerecord-jdbc-adapter.git", platforms: :jruby
  gem 'activerecord-sqlserver-adapter',
    git: 'https://github.com/xiuzhong/activerecord-sqlserver-adapter',
    branch: 'jdbc-mode'
  gem 'sqljdbc4', platform: :jruby, require: true, git: 'https://github.com/iaddict/sqljdbc4-java.git'
else
  gem "ruby-prof", require: false
end