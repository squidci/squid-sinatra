class TestSuite < ActiveRecord::Base

  scope :recent_build_ids, -> { select(:build_id).distinct.pluck(:build_id) }

end
