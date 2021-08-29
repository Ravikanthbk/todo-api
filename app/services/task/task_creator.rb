class Task::TaskCreator < ApplicationService
  def initialize(title:, tags:)
    @title = title
    @tags = tags
  end

  def call
    create_task
  end

  private

  def create_task
    task = Task.new({title: @title})
    find_or_create_tags(@tags, task) if task.save!
    task
  end
end