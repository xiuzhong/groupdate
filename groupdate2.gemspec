require_relative "lib/groupdate/version"

Gem::Specification.new do |spec|
  spec.name          = "groupdate2"
  spec.version       = Groupdate::VERSION
  spec.summary       = "The simplest way to group temporal data"
  spec.homepage      = "https://github.com/xiuzhong/groupdate2"
  spec.license       = "MIT"

  spec.author        = "Leo li"
  spec.email         = "lxz.tty@gmail.com"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.4"

  spec.add_dependency "activesupport", ">= 5"

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
    spec.add_development_dependency "pg"
    spec.add_development_dependency "mysql2"
    spec.add_development_dependency "sqlite3"
    spec.add_development_dependency 'activerecord-sqlserver-adapter'
  end
end
