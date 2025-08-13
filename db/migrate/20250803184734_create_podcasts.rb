class CreatePodcasts < ActiveRecord::Migration[8.0]
  def change
    # NOTE: SQLite does not support comments, but they still serve as useful documentation.
    create_table :podcasts do |t|
      t.references :owner, foreign_key: { to_table: :users, on_delete: :nullify }, comment: 'Not required because records may be created by a background process'
      t.string     :title,       null: false, default: ''
      t.text       :description, null: false, default: ''
      t.datetime   :published_at
      t.datetime   :deleted_at
      t.timestamps
    end

    create_table :episodes do |t|
      t.references  :owner, foreign_key: { to_table: :users, on_delete: :nullify }, comment: 'Not required because records may be created by a background process'
      t.references  :podcast,     null: false, foreign_key: { on_delete: :cascade }
      t.string      :title,       null: false, default: ''
      t.text      :description, null: false, default: ''
      t.json        :metadata,    null: false, default: {}, comment: 'For storing ID3 tags from user uploaded files'
      t.datetime    :published_at
      t.datetime    :deleted_at
      t.timestamps
      # WARNING: SQL is sqlite specific.
      # This is enforced at the database level because validations can be skipped.
      # As soon as you have one invalid record you will likely have problems for the life of the application.
      t.check_constraint "json_type(metadata) = 'object'", name: 'chk_metadata_is_object'
    end
  end
end
