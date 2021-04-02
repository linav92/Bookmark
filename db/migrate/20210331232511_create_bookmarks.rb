class CreateBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmarks do |t|
      t.string :title
      t.string :url
      t.belongs_to :category, null: true, foreign_key: true
      t.belongs_to :kind, null: true, foreign_key: true
      t.timestamps
    end
  end
end
