require 'pry'
require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDERR)


require './models/item'
require './db_config'

binding.pry
