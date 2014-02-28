# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    title { Faker::Commerce.product_name }
    url { Faker::Internet.domain_name}
    body { Faker::Lorem.paragraph(3)}

  end
end
