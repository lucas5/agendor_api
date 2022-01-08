# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :room do
    association :office
    name { 'Sala 1' }
  end
end
