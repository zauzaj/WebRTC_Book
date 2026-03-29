class CreateGlCodes < ActiveRecord::Migration[7.2]
  def change
    create_table :gl_codes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :quickbooks_id
      t.string :name
      t.string :account_type
      t.string :account_number

      t.timestamps
    end
  end
end
