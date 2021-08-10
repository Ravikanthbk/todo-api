class Task < ApplicationRecord
  has_and_belongs_to_many :tags

  validates :title, presence: true
  validates :title, uniqueness: true
    
  # def tag_list
  #   self.tags.collect do |tag|
  #     tag.name
  #   end
  #   # end.join(", ")
  # end
end
