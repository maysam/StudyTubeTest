# frozen_string_literal: true

FactoryBot.define do
  sequence :stock_name do |n|
    "stock #{n}"
  end
  factory :stock do
    name { generate :stock_name }
    bearer
  end
end
