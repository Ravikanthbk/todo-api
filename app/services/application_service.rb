class ApplicationService
  def self.call(**args)
    new(**args).call
  end

  private

  def find_or_create_tags(tags = [], task)
    tags.each do |tag_title|      
      tag = Tag.find_by_title(tag_title)
      unless tag.nil?
        task_tags = task.tags.collect(&:title).include?(tag.title)
        unless task_tags
          task.tags << tag
        end        
      else
        task.tags.create(title: tag_title)
      end
    end
  end  
end