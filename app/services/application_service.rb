class ApplicationService
  def self.call(**args)
    new(**args).call
  end

  private

  def find_or_create_tags(tags = [], task)  
    tags_exist = Tag.where(:title => tags) unless tags.size.eql?(0)
    tags.each do |tag_title|
      matched_tag = tags_exist.find { |tag| tag.title.eql?(tag_title) }
      matched_tag.nil? ? task.tags.create(title: tag_title) : task.tags << matched_tag    
    end
  end  
end