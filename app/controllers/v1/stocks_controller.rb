# frozen_string_literal: true

module V1
  class StocksController < ApplicationController
    def index
      render json: Stock.not_archived, each_serializer: V1::StockSerializer
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
      stock = Stock.not_archived.find(params[:id])
      if stock.update_by_params(stock_params)
        render json: stock, status: :ok
      else
        render json: { errors: stock.errors }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid
      render json: { errors: { bearer: [ErrorMessages.invalid_params] } }, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound
      render json: { errors: { stock: [ErrorMessages.record_not_found] } }, status: :not_found
    end

    def destroy
      stock = Stock.not_archived.find(params[:id])
      if stock.archive
        render status: :ok
      else
        render json: { errors: stock.errors }, status: :unprocessable
      end
    rescue ActiveRecord::RecordNotFound
      render json: { errors: { stock: [ErrorMessages.record_not_found] } }, status: :not_found
    end

    private

    def stock_params
      params.require(:stock).permit(:name, :bearer)
    end
  end
end
