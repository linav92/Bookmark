class BookmarksController < ApplicationController
  before_action :set_bookmark, only: %i[ show edit update destroy ]

  # GET /bookmarks or /bookmarks.json
  def index
    @bookmarks = Bookmark.all
    @bookmark = Bookmark.new
  end

  # GET /bookmarks/1 or /bookmarks/1.json
  def show
  end

  # GET /bookmarks/new
  def new
    @bookmark = Bookmark.new
  end

  # GET /bookmarks/1/edit
  def edit
  end

  # POST /bookmarks or /bookmarks.json
  def create
    @bookmark = Bookmark.new
    @bookmark.title= params[:bookmark][:title]
    @bookmark.url= params[:bookmark][:url]
    @bookmark.category_ids= params[:bookmark][:category_id]
    @bookmark.kind_ids= params[:bookmark][:kind_id]
    @bookmark.save

    params[:bookmark][:category_ids].each do |cID| 
      if cID != ""
        @bookmarkcategory = BookmarkCategory.new
        @bookmarkcategory.category_id= cID
        @bookmarkcategory.bookmark_id = @bookmark.id
        @bookmarkcategory.save
      end 
    end 

    params[:bookmark][:kind_ids].each do |kID| 
      if kID != ""
        @bookmarkcategory = BookmarkKind.new
        @bookmarkcategory.kind_id= kID
        @bookmarkcategory.bookmark_id = @bookmark.id
        @bookmarkcategory.save
      end 
    end 
    
    respond_to do |format|
      if @bookmark.save
        format.js {redirect_to bookmarks_path, notice: "Bookmark was successfully created."  }
        format.html { redirect_to @bookmark, notice: "Bookmark was successfully created." }
        format.json { render :show, status: :created, location: @bookmark }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookmarks/1 or /bookmarks/1.json
  def update
    params[:bookmark][:category_ids].each do |cID| 
      if cID != ""
        @bookmarkcategory = BookmarkCategory.new
        @bookmarkcategory.category_id= cID
        @bookmarkcategory.bookmark_id = @bookmark.id
        @bookmarkcategory.save
      end 
    end 

    params[:bookmark][:kind_ids].each do |kID| 
      if kID != ""
        @bookmarkcategory = BookmarkKind.new
        @bookmarkcategory.kind_id= kID
        @bookmarkcategory.bookmark_id = @bookmark.id
        @bookmarkcategory.save
      end 
    end 
    respond_to do |format|
      if @bookmark.update(bookmark_params)
        format.js  { redirect_to bookmarks_path, notice: "title was successfully created." }
        format.html { redirect_to @bookmark, notice: "Bookmark was successfully updated." }
        format.json { render :show, status: :ok, location: @bookmark }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1 or /bookmarks/1.json
  def destroy
    @bookmark.destroy
    respond_to do |format|
      format.html { redirect_to bookmarks_url, notice: "Bookmark was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bookmark_params
      params.require(:bookmark).permit(:title, :url, category_id: [], kind_id: [])
    end
end
