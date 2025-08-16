class AddMetadataToEpisodes < ActiveRecord::Migration[8.0]
  def change
    change_table :episodes do |t|
      t.integer :length, null: false, default: 0, comment: "In seconds"
      t.integer :bitrate, null: false, default: 0, comment: "In kbps"
    end
  end
end
