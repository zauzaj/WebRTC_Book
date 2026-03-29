class AddVectorIndexes < ActiveRecord::Migration[7.2]
  def up
    execute "CREATE INDEX gl_codes_embedding_idx ON gl_codes USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100)"
    execute "CREATE INDEX invoices_embedding_idx ON invoices USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100)"
  end

  def down
    remove_index :gl_codes, name: :gl_codes_embedding_idx
    remove_index :invoices, name: :invoices_embedding_idx
  end
end
