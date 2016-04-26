require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'farmerapp'
}

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || options)
