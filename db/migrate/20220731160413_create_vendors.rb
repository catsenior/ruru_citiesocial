class CreateVendors < ActiveRecord::Migration[6.1]
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :address
      t.string :tel
      t.text :description
      t.boolean :online, default: true

      t.timestamps
    end
  end
end
