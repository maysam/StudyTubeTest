# frozen_string_literal: true

class Stock < ApplicationRecord
  include Archivable

  belongs_to :bearer

  validates :name, uniqueness: { message: ErrorMessages.already_exists }
  validates :name, presence: { message: ErrorMessages.missing }
  validates :bearer, presence: { message: ErrorMessages.missing }
end
