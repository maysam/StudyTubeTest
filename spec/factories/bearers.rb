# frozen_string_literal: true

FactoryBot.define do
  sequence :bearer_name do |n|
    "bearer #{n}"
  end
  factory :bearer do
    name { generate :bearer_name }
  end
end
