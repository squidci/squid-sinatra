class AddTestSuiteStartedAtToTests < ActiveRecord::Migration
  def change
    add_column :tests, :test_suite_started_at, :datetime
  end
end
