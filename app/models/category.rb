class Category < ApplicationRecord
  belongs_to :parent_category, :class_name => "Category", :foreign_key => "category_id", :optional => true
  has_many :children_categories, class_name: "Category", :foreign_key => "category_id"
  
  #relaciones con la tabla intermedia
  has_many :bookmark_categories
  has_many :bookmarks, through: :bookmark_categories

  validates :title, presence: true
  
  def to_s
    title
  end
end
