# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    community nil
    user nil
    text "MyText"
  end
end
