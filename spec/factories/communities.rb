# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :community do
    sequence(:name) {|n| "Community #{n}"}
    association :owner, factory: :user
    photo { File.open(Rails.root.join( 'spec/fixtures/trbmeetup.jpeg')) }
  end
end
