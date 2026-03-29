class CreateInvoices < ActiveRecord::Migration[7.2]
  def change
    create_table :invoices do |t|
      t.references :user, null: false, foreign_key: true
      t.references :vendor, null: false, foreign_key: true
      t.string :status
      t.decimal :total_amount
      t.string :invoice_number
      t.date :invoice_date
      t.date :due_date
      t.string :pdf_url
      t.text :raw_text
      t.float :confidence_score
      t.text :notes

      t.timestamps
    end
  end
end
