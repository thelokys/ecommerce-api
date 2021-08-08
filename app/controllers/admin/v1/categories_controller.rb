module Admin::V1
  class CategoriesController < ApiController

    # GET: /admin/v1/categories
    def index
      @categories = Category.all
    end

    def create
      @category = Category.new
      @category.attributes = category_params
      save_category!
    end

    def category_params
      return {} unless params.has_key?(:category)
      params.require(:category).permit(:name)
    end

    def save_category!(status: :created)
      @category.save!
      render :show, status: status
      rescue
        render_error(fields: @category.errors.messages)
    end
  end
end
