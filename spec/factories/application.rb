if defined? Doorkeeper
  FactoryGirl.define do
    factory :application, class: Doorkeeper::Application  do
      sequence(:name){ |n| "Application #{n}" }
      redirect_uri "https://example.com/callback"
    end
  end
end
