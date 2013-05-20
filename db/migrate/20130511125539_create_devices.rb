class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :affiliate
      t.string :headend
      t.string :deviceModel
      t.string :ipAddress
      t.string :osType
      t.string :osVersion
      t.string :biv

      t.timestamps
    end
  end
end
