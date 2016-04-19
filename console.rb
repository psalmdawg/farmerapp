require 'pry'
require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDERR)


require './models/item'
require './models/user'
require './db_config'

binding.pry
