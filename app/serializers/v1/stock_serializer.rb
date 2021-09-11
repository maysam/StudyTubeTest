# frozen_string_literal: true

module V1
  class StockSerializer < ActiveModel::Serializer
    attributes :id, :name, :created_at, :updated_at, :bearer

    def bearer
      object.bearer.name
    end

    def created_at
      object.created_at.to_s
    end

    def updated_at
      object.updated_at.to_s
    end
  end
end
