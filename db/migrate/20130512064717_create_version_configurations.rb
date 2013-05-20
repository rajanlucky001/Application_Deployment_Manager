class CreateVersionConfigurations < ActiveRecord::Migration
  def change
    create_table :version_configurations do |t|
      t.string :key
      t.string :value
      t.references :version

      t.timestamps
    end
    add_index :version_configurations, :version_id
  end
end
