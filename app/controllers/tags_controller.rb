class TagsController < ApplicationController
  def index
    tags = Tag.search(search_params).reselect(:id, :name)
    render json: tags
  end

  def create
    tag = Tag.new(tag_params)

    if tag.save
      render json: { id: tag.id, name: tag.name }
    else
      render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity # HTTP status 422
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  def search_params
    params.permit(:name)
  end
end
