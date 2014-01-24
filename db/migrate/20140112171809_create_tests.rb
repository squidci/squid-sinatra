class CreateTests < ActiveRecord::Migration
  def change
		create_table :tests do |t|
  		t.integer :build_id

			t.string :status
			t.text   :test_group
			t.text   :description

			t.datetime :started_at
			t.datetime :finished_at
			t.float    :runtime

			t.timestamps
  	end

		add_index :tests, [:build_id]
  end
end
