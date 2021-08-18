FactoryBot.define do
  factory :task do
    title { 'Wash laundry' }
    after(:create) {|task| task.tags = [create(:tag, {title: Faker::Name.unique.name})]}
  end
  
  factory :random_task, class: Task do
    title { Faker::Name.unique.name }
  end

  factory :task_tags, class: Task do
    title {'Wash laundry' }
  end

end

# Factory.define :company do |f|
#   f.tags { |tags| [tags.association :task]}
# end