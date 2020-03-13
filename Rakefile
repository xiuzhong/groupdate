require "bundler/gem_tasks"
require "rake/testtask"

ADAPTERS = %w(postgresql mysql sqlite enumerable redshift)

ADAPTERS.each do |adapter|
  namespace :test do
    task("env:#{adapter}") { ENV["ADAPTER"] = adapter }

    Rake::TestTask.new(adapter => "env:#{adapter}") do |t|
      t.description = "Run tests for #{adapter}"
      t.libs << "test"
      # TODO permit works for enumerable, just need to make tests work
      exclude = adapter == "enumerable" ? /database|multiple_group|permit/ : /enumerable/
      t.test_files = FileList["test/**/*_test.rb"].exclude(exclude)
    end
  end
end

desc "Run all adapter tests besides redshift"
task :test do
  ADAPTERS.each do |adapter|
    next if adapter == "redshift"
    Rake::Task["test:#{adapter}"].invoke
  end
end

desc "Update the time zone mapping: Windows timezone IDs to the standard TZIDs"
task :update_tzmap do
  require 'net/http'
  require 'json'
  uri = 'https://raw.githubusercontent.com/unicode-cldr/cldr-core/master/supplemental/windowsZones.json'
  json_file = 'lib/groupdate/windows_zones.json'
  json = JSON.parse(Net::HTTP.get(URI(uri)))
  # json['supplemental']['windowsZones']['mapTimezones'].last
  # => {"mapZone"=>{"_other"=>"Yakutsk Standard Time", "_type"=>"Asia/Yakutsk Asia/Khandyga", "_territory"=>"RU"}}
  mapping_r2w = json['supplemental']['windowsZones']['mapTimezones'].each_with_object({}) do |z, r2w|
    map_zone = z['mapZone']
    map_zone['_type'].split.each { |type| r2w[type] = map_zone['_other'] }
  end
  File.open(json_file, 'w') { |file| file.write(mapping_r2w.to_json) }
  puts "The windowsZones file is updated: #{json_file}"
end

task default: :test

desc "Profile call"
task :profile do
  require "active_record"
  require "sqlite3"
  require "groupdate"
  require "ruby-prof"

  # RubyProf.measure_mode = RubyProf::ALLOCATIONS

  ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

  ActiveRecord::Migration.create_table :users, force: true do |t|
    t.timestamp :created_at
  end

  class User < ActiveRecord::Base
  end

  now = Time.now
  10000.times do |n|
    User.create!(created_at: now - n.days)
  end

  result = RubyProf.profile do
    User.group_by_day(:created_at).count
  end

  printer = RubyProf::GraphPrinter.new(result)
  printer.print(STDOUT, {})
end
