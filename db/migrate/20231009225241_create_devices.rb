class CreateDevices < ActiveRecord::Migration[7.0]
  def change
    create_table :devices do |t|
      t.string :secret, null: false
      t.string :device_id, null: false
      t.references :client, null: false, foreign_key: true

      t.timestamps

      t.index ["device_id"], name: "index_devices_on_device_id"
    end
  end
end
