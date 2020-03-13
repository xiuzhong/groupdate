# --------------------------------------------------------------------
# CREATE DATABASE groupdate_test;
# USE groupdate_test;

# CREATE LOGIN groupdate_test WITH PASSWORD = 'Groupdate_Test';
# CREATE USER groupdate_test FOR LOGIN groupdate_test;
# EXEC sp_addrolemember 'db_owner', 'groupdate_test';
# GO
# --------------------------------------------------------------------
if RUBY_PLATFORM == "java"
  require 'java'
  ActiveRecord::Base.establish_connection adapter: 'sqlserver', host: '127.0.0.1', mode: :jdbc, database: 'groupdate_test', username: 'groupdate_test', password: 'Groupdate_Test'
else
  ActiveRecord::Base.establish_connection adapter: 'sqlserver', host: '127.0.0.1', database: 'groupdate_test', username: 'groupdate_test', password: 'Groupdate_Test'
end
