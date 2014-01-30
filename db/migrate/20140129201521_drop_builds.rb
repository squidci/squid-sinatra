class DropBuilds < ActiveRecord::Migration
  def up
    drop_table :builds
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
