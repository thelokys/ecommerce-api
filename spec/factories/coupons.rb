FactoryBot.define do
  factory :coupon do
    code { Faker::Commerce.unique.promotion_code(digits: 4) }
    status { :active }
    discount_value { 25 }
    due_date { 3.days.from_now }
  end
end
