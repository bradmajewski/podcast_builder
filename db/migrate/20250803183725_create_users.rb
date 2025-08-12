class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string  :email,            null: false, index: { unique: true }
      t.string  :password_digest,  null: false
      t.boolean :admin,            null: false, default: false
      t.datetime :verified_at
      t.timestamps
    end
  end
end
