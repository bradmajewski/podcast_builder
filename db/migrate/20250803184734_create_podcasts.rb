class CreatePodcasts < ActiveRecord::Migration[8.0]
  def change
    create_table :podcasts do |t|
      t.references :user,  foreign_key: true
      t.string :title,     null: false, default: ''
      t.text :description, null: false, default: ''
      t.datetime :published_at

      t.timestamps
    end

    create_table :episodes do |t|
      t.references :user,     foreign_key: true
      t.references :podcast,  null: false, foreign_key: true
      t.string :title,        null: false, default: ''
      t.string :description,  null: false, default: ''
      t.json :metadata,       null: false, default: {}
      t.datetime :published_at

      t.timestamps
      t.check_constraint "json_type(metadata) = 'object'", name: 'chk_metadata_is_object'
    end
  end
end
