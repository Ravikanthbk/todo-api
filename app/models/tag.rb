class Tag < ApplicationRecord
  has_and_belongs_to_many :tasks

  validates :title, presence: true
  validates :title, uniqueness: true
end
