require 'active_support/time'
require 'active_record'

Time.zone = 'Berlin'
ActiveRecord::Base.time_zone_aware_attributes = true
ActiveRecord::Base.default_timezone = :local
