class CreateBookmarkKinds < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmark_kinds do |t|
      t.references :bookmark, null: false, foreign_key: true
      t.references :kind, null: false, foreign_key: true

      t.timestamps
    end
  end
end
