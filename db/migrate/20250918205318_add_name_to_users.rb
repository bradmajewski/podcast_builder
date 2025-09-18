class AddNameToUsers < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.string :name
    end
  end
end
