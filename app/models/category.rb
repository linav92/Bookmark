class Category < ApplicationRecord
  # has_many :bookmarks
  belongs_to :parent_category, :class_name => "Category", :foreign_key => "category_id", :optional => true
  has_many :children_categories, class_name: "Category", :foreign_key => "category_id"

  validates :title, presence: true
  
  def to_s
    title
  end
end
