source "https://rubygems.org"

# Specify your gem's dependencies in groupdate.gemspec
gemspec

gem "activerecord", "~> 5.2.0"
gem 'byebug', platforms: :ruby

if defined?(JRUBY_VERSION)
  gem 'activerecord-jdbc-adapter'
  gem 'activerecord-sqlserver-adapter',
    git: 'https://github.com/xiuzhong/activerecord-sqlserver-adapter',
    branch: 'jdbc-mode'
  gem 'sqljdbc4', platform: :jruby, require: true, git: 'https://github.com/iaddict/sqljdbc4-java.git'
end

gem "ruby-prof", require: false, platforms: :ruby
