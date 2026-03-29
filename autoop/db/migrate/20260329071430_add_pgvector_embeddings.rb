class AddPgvectorEmbeddings < ActiveRecord::Migration[7.2]
  def up
    enable_extension "vector"
    add_column :invoices, :embedding, :vector, limit: 1536
    add_column :gl_codes, :embedding, :vector, limit: 1536
  end

  def down
    remove_column :invoices, :embedding
    remove_column :gl_codes, :embedding
    disable_extension "vector"
  end
end
