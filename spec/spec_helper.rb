require "rspec"
require "train"
require "city"
require "user"
require "pg"
require "pry"

DB = PG.connect({:dbname => 'trains_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM trains *;")
    DB.exec("DELETE FROM cities *;")
    DB.exec("DELETE FROM stops *;")
  end
end
