FactoryBot.define do
  factory :task do
    title { 'Wash laundry' }
    # tags {[FactoryBot.create(:tag)]}
  end

  factory :random_task, class: Task do
    title { Faker::Name.unique.name }
  end

end