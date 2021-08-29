FactoryBot.define do
  factory :tag do
    title { 'Home' }    
  end

  factory :random_tag, class: Tag do
    title { Faker::Name.unique.name }
  end  
end
