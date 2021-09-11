# frozen_string_literal: true

module V1
  class StocksController < ApplicationController
    before_action :find_stock, only: %i[update destroy]

    def index
      render json: Stock.not_archived.includes(:bearer), each_serializer: V1::StockSerializer
    end

    def create
      bearer = Bearer.find_or_create_by!(name: stock_params[:bearer])
      stock = bearer.stocks.new name: stock_params[:name]
      if stock.save
        render json: stock, status: :created
      else
        render json: { errors: stock.errors }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid
      render json: { errors: { bearer: [ErrorMessages.invalid_params] } }, status: :unprocessable_entity
    end

    def update
      if @stock.update_by_params(stock_params)
        render json: @stock, status: :ok
      else
        render json: { errors: @stock.errors }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid
      render json: { errors: { bearer: [ErrorMessages.invalid_params] } }, status: :unprocessable_entity
    end

    def destroy
      if @stock.archive
        render status: :ok
      else
        render json: { errors: @stock.errors }, status: :unprocessable
      end
    end

    private

    def find_stock
      @stock = Stock.not_archived.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: { stock: [ErrorMessages.record_not_found] } }, status: :not_found
    end

    def stock_params
      params.require(:stock).permit(:name, :bearer)
    end
  end
end
