class CreateInvoiceLineItems < ActiveRecord::Migration[7.2]
  def change
    create_table :invoice_line_items do |t|
      t.references :invoice, null: false, foreign_key: true
      t.references :gl_code, null: false, foreign_key: true
      t.text :description
      t.decimal :amount
      t.float :quantity
      t.decimal :unit_price
      t.float :confidence_score

      t.timestamps
    end
  end
end
