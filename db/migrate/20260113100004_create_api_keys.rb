class CreateApiKeys < ActiveRecord::Migration[8.1]
  def change
    create_table :api_keys do |t|
      t.references :enterprise, null: false, foreign_key: true
      t.string :name, null: false
      t.string :key_prefix, null: false
      t.string :key_digest, null: false
      t.string :environment, default: "production"
      t.string :status, default: "active"
      t.datetime :last_used_at
      t.text :allowed_ips
      t.text :allowed_origins

      t.timestamps
    end

    add_index :api_keys, :key_digest, unique: true
    add_index :api_keys, :key_prefix
    add_index :api_keys, :status
  end
end
