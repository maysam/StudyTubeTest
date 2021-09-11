# frozen_string_literal: true

class Stock < ApplicationRecord
  include Archivable

  belongs_to :bearer

  validates :name, uniqueness: { message: ErrorMessages.already_exists }
  validates :name, presence: { message: ErrorMessages.missing }
  validates :bearer, presence: { message: ErrorMessages.missing }

  def update_by_params(params)
    self.name = params[:name]
    self.bearer_id = Bearer.find_or_create_by!(name: params[:bearer]).id
    save
  end
end
