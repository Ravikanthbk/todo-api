require 'rails_helper'

RSpec.describe Task, type: :model do
  # Association test
  context "Associations" do
    it { should have_and_belong_to_many(:tags) }
  end
  
  # Validation tests
  context "Validations" do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title) }
  end
  
end