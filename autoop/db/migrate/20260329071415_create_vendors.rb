class CreateVendors < ActiveRecord::Migration[7.2]
  def change
    create_table :vendors do |t|
      t.references :user, null: false, foreign_key: true
      t.string :quickbooks_id
      t.string :name
      t.string :email
      t.string :phone
      t.text :address

      t.timestamps
    end
  end
end
