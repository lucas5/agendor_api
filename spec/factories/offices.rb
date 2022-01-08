# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :office do
    name { 'GetNinjas' }
    capacity { 4 }
  end
end
