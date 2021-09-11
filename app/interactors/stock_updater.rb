# frozen_string_literal: true

class StockUpdater
  include Interactor

  def call
    stock = context.stock
    params = context.params
    stock.name = params[:name]
    ActiveRecord::Base.transaction do
      stock.bearer_id = Bearer.find_or_create_by!(name: params[:bearer]).id if params[:bearer].present?
      context.fail!(errors: stock.errors) unless stock.save
    end
  end
end
