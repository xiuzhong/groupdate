
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "groupdate/version"

Gem::Specification.new do |spec|
  spec.name          = "groupdate2"
  spec.version       = Groupdate::VERSION
  spec.summary       = "groupdate with support of SQL Server 2016+"
  spec.homepage      = "https://github.com/xiuzhong/groupdate2"
  spec.license       = "MIT"

  spec.author        = "Leo Li"
  spec.email         = "lxz.tty@gmail.com"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.2"

  spec.add_dependency "activesupport", ">= 4.2"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "activerecord"

  if RUBY_PLATFORM == "java"
    spec.add_development_dependency "activerecord-jdbcpostgresql-adapter"
    spec.add_development_dependency "activerecord-jdbcmysql-adapter"
    spec.add_development_dependency "activerecord-jdbcsqlite3-adapter"
    spec.add_development_dependency 'activerecord-sqlserver-adapter'
  else
    spec.add_development_dependency "pg", "< 1"
    spec.add_development_dependency "mysql2", "< 0.5"
    spec.add_development_dependency "sqlite3", "~> 1.3.0"
    spec.add_development_dependency 'activerecord-sqlserver-adapter'
    spec.add_development_dependency "byebug"
  end
end
