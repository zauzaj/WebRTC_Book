class CreateQuickBooksConnections < ActiveRecord::Migration[7.2]
  def change
    create_table :quick_books_connections do |t|
      t.references :user, null: false, foreign_key: true
      t.text :access_token
      t.text :refresh_token
      t.datetime :token_expires_at
      t.string :realm_id
      t.boolean :connected

      t.timestamps
    end
  end
end
