class Api::V1::TasksController < ApplicationController
  def index
    tasks = paginate(Task.all.includes(:tags))
    response = tasks.to_json(:include => {:tags => {only: [:title]}})
    render json: response
  end

  def create
    task = Task::TaskCreator.call(title: task_param[:title], tags: params[:tags])
    response = task.to_json(:include => {:tags => {only: [:title]}})
    render json: response
  end

  def update
    task = Task::TaskUpdater.call(id: params[:id], title: task_param[:title], tags: params[:tags])
    response = task.to_json(:include => {:tags => {only: [:title]}})
    render json: response
  end
      
  private
    def task_param
      params.require(:task).permit(:title, :id)
    end
end
