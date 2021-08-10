FactoryBot.define do
  factory :tag do
    title { 'Home' }    
  end

  # factory :task do
  #   tags {[FactoryBot.create(:tag)]}
  #   #user attributes
  #  end

  factory :random_tag, class: Tag do
    title { Faker::Name.unique.name }
  end  
end
