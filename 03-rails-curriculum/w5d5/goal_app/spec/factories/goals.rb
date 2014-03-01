# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :goal do
    title { Faker::Company.name }
    description { Faker::Lorem.paragraph(5) }
  end
end
