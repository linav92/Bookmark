class ApiController < ApplicationController

    def api
        @category = Category.where("category_id is null").includes(:children_categories)
        render json: @category.to_json(:include =>[:children_categories,:bookmarks])

    end

    def apiID
        category = Category.find(params[:id])
        hash = {
          title: category.title,
          is_public: category.is_public,
          parent_category: category.parent_category,
          children_categories: category.children_categories,
          bookmarks: category.bookmarks.pluck(:title)
        }
        render json: hash
    end
    
end