require 'rails_helper'

RSpec.describe Tag, type: :model do
  # Association test
  context "Associations" do
    it { should have_and_belong_to_many(:tasks) }
  end
  # Validation tests
  context "Validations" do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title) }
  end

 end