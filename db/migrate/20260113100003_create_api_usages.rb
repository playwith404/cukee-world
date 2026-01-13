class CreateApiUsages < ActiveRecord::Migration[8.1]
  def change
    create_table :api_usages do |t|
      t.references :enterprise, null: false, foreign_key: true
      t.references :access_token, foreign_key: true
      t.string :endpoint, null: false
      t.string :method, null: false
      t.integer :response_code, null: false
      t.integer :response_time_ms
      t.string :client_ip
      t.string :user_agent
      t.decimal :cost, precision: 8, scale: 4, default: 0
      t.jsonb :metadata

      t.timestamps
    end

    add_index :api_usages, :endpoint
    add_index :api_usages, :response_code
    add_index :api_usages, :created_at
    add_index :api_usages, [ :enterprise_id, :created_at ]
  end
end
