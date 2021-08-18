class Task::TaskUpdater < ApplicationService
  def initialize(id:, title:, tags:)
    @id = id
    @title = title
    @tags = tags
  end

  def call
    update_task
  end

  private

  def update_task
    task = Task.find(@id)
    find_or_create_tags(@tags, task) if task.update!({title: @title})
    task
  end
end