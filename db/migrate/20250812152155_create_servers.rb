class CreateServers < ActiveRecord::Migration[8.0]
  def change
    create_table :servers do |t|
      t.references :owner, foreign_key: { to_table: :users, on_delete: :nullify }, comment: 'Not required because records may be created by a background process'
      t.string     :name
      t.string     :host,        null: false
      t.integer    :port,        null: false, default: 22
      t.string     :user,        null: false
      t.text       :private_key, null: false
      t.string     :host_key
      t.datetime   :last_login_at
      t.datetime   :deleted_at
      t.timestamps
    end

    create_table :feeds do |t|
      t.references :server,  null: false, foreign_key: { on_delete: :restrict }
      t.references :podcast, null: false, foreign_key: { on_delete: :restrict }
      t.string     :url,     null: false
      t.string     :path,    null: false
      t.datetime   :last_upload_at
      t.datetime   :deleted_at
      t.timestamps
    end
  end
end
