class AddIndexesToTestSuites < ActiveRecord::Migration
  def change
    add_index :test_suites, [:build_id, :started_at]
  end
end
