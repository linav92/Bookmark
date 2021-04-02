class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :title
      t.boolean :is_public
      t.belongs_to :category, null: true, foreign_key: true
      t.timestamps
    end
  end
end
