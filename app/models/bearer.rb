# frozen_string_literal: true

class Bearer < ApplicationRecord
  has_many :stocks, dependent: :destroy

  validates :name, uniqueness: { message: ErrorMessages.already_exists }
  validates :name, presence: { message: ErrorMessages.missing }
end
