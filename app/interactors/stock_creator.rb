# frozen_string_literal: true

class StockCreator
  include Interactor

  def call
    params = context.params
    ActiveRecord::Base.transaction do
      bearer = Bearer.find_or_create_by!(name: params[:bearer])
      stock = bearer.stocks.new name: params[:name]
      if stock.save
        context.stock = stock
      else
        context.fail!(errors: stock.errors)
      end
    end
  end
end
