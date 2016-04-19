require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'farmerapp'
}

ActiveRecord::Base.establish_connection(options)
