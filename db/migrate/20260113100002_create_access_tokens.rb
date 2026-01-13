class CreateAccessTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :access_tokens do |t|
      t.references :enterprise, null: false, foreign_key: true
      t.string :token_digest, null: false
      t.string :name, default: "Default Token"
      t.string :status, default: "active"
      t.datetime :expires_at
      t.datetime :last_used_at
      t.string :last_used_ip
      t.integer :usage_count, default: 0

      t.timestamps
    end

    add_index :access_tokens, :token_digest, unique: true
    add_index :access_tokens, :status
    add_index :access_tokens, :expires_at
  end
end
