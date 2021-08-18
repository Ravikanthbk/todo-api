class Api::V1::TagsController < ApplicationController
  def index    
    tags = paginate(Tag.all)
    render json: tags
  end

  def create
    tag = Tag.new(tag_param)
    tag.save!
    render json: tag, status: :created
  end

  def update
    tag = Tag.find(params[:id])
    tag.update!(tag_param)
    render json: tag
  end
  
  private
    def tag_param
      params.require(:tag).permit(:title, :id)
    end  
end
