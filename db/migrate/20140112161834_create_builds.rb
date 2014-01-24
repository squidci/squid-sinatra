class CreateBuilds < ActiveRecord::Migration
  def change
		create_table :builds do |t|
  		t.integer :build_id

			t.integer :passed_count,  null: false, default: 0
			t.integer :failed_count,  null: false, default: 0
			t.integer :pending_count, null: false, default: 0
			t.integer :total_count,   null: false, default: 0

			t.string  :status

			t.datetime :started_at
			t.datetime :finished_at
			t.float    :duration

			t.timestamps
  	end

		add_index :builds, [:build_id], unique: true
  end
end
