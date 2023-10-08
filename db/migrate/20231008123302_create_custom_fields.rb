class CreateCustomFields < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_fields do |t|
      t.string :name
      t.string :value
      t.references :custom_fieldable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
