class Build < ActiveRecord::Base

  scope :recent, -> { order('build_id DESC') }

end
