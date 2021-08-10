class Api::V1::TasksController < ApplicationController
  def index
    tasks = paginate(Task.all)
    render json: tasks.to_json(:include => {:tags => {only: [:title]}})    
  end

  def create
    task = Task.new(task_param)
    Task.transaction do
      if task.save!
        find_or_create_tags(params[:tags], task)
      end
      render json: task.to_json(:include => {:tags => {only: [:title]}})
    end
  end

  def update
    task = Task.find(params[:id])
    Task.transaction do
      if task.update!(task_param)
        find_or_create_tags(params[:tags], task)
        render json: task.to_json(:include => {:tags => {only: [:title]}})
      end
    end
  end

  def find_or_create_tags(param_tags = [], task)
    param_tags.each do |tag_param|      
      tag = Tag.find_by_title(tag_param)
      if tag.nil?
        task.tags.create(title: tag_param)
      else
        task_tags = task.tags.collect(&:title).include?(tag.title)
        unless task_tags
          task.tags << tag
        end
      end
    end
  end        

  # def destroy
  #   task = Task.find(params[:id])
  #   task.destroy
  #   head :no_content, status: :ok
  # end
  
  private
    def task_param
      params.require(:task).permit(:title, :tags)
    end
end
