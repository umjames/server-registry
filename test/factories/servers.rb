# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :server do
  	hostname "www.apple.com"
  	ip_address "1.2.3.4"
  end
end
