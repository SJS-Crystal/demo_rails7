class CreateCustomFields < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_fields do |t|
      t.string :name, null: false
      t.string :value, null: false
      t.references :custom_fieldable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
