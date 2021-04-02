class Bookmark < ApplicationRecord
    hbelongs_to :category, optional: true
    belongs_to :kind, optional: true
end
