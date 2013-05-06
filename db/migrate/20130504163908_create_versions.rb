class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string :version
      t.references :application

      t.timestamps
    end
    add_index :versions, :application_id
  end
end
