# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StockUpdater, type: :interactor do
  describe '.call' do
    it 'updates the stock name' do
      stock = create(:stock, name: 'YAHOO')
      result = described_class.call(stock: stock, params: { name: 'APPL' })
      expect(result.stock.name).to eq 'APPL'
    end
  end
end
