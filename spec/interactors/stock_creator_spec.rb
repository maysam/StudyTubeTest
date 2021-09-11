# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StockCreator, type: :interactor do
  describe '.call' do
    it 'creates new stock' do
      result = described_class.call(params: { name: 'APPL', bearer: 'DHH' })
      expect(result.stock.name).to eq 'APPL'
      expect(result.stock.bearer.name).to eq 'DHH'
    end
  end
end
