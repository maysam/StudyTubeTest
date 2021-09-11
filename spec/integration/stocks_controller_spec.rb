# frozen_string_literal: true

require 'swagger_helper'

describe Stock do
  path '/v1/stocks' do
    get 'Gets all stocks' do
      tags 'Stocks'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'gets all the stocks' do
        schema type: :array,
               items: {
                 properties: {
                   id: { type: :number, example: 85 },
                   name: { type: :string, example: 'good stock' },
                   bearer: { type: :string, example: 'good bearer' },
                   updated_at: { type: :string, example: '2021-01-26T23:00:00+01:00' },
                   created_at: { type: :string, example: '2021-01-26T23:00:00+01:00' }
                 }
               }
        let!(:stock) { create(:stock) }

        run_test! do
          expect(JSON.parse(response.body)).to eq([V1::StockSerializer.new(stock).as_json.stringify_keys])
        end
      end
    end

    post 'Creates new stock' do
      tags 'Stocks'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          stock: {
            type: :object,
            properties: {
              name: { type: :string, example: 'stock name' },
              bearer: { type: :string, example: 'bearer name' }
            },
            required: %w[name bearer]
          }
        },
        required: %w[stock]
      }
      let(:params) do
        {
          stock: stock_params
        }
      end
      let(:bearer) { create(:bearer) }

      response '201', 'creates new stock with existing bearer' do
        let(:stock_params) do
          {
            name: 'new stock',
            bearer: bearer.name
          }
        end

        run_test! do
          expect(bearer.stocks.count).to eq 1
        end
      end

      response '201', 'creates new stock with new bearer' do
        let(:stock_params) do
          {
            name: 'new stock',
            bearer: 'new bearer'
          }
        end

        run_test! do
          expect(bearer.stocks.count).to eq 0
          stock = Stock.last
          expect(stock.name).to eq 'new stock'
          expect(stock.bearer.name).to eq 'new bearer'
        end
      end

      response '422', 'does not create new stock with duplicate name' do
        let(:old_stock) { create(:stock) }
        let(:stock_params) do
          {
            name: old_stock.name,
            bearer: 'new bearer'
          }
        end

        run_test! do
          errors = JSON.parse(response.body)['errors']

          expect(errors['name']).to eq([ErrorMessages.already_exists])
        end
      end

      response '422', 'invalid bearer param' do
        let(:stock_params) { { name: '', bearer: '' } }

        run_test! do
          errors = JSON.parse(response.body)['errors']

          expect(errors['bearer']).to eq([ErrorMessages.invalid_params])
        end
      end

      response '422', 'invalid stock param' do
        let(:stock_params) { { name: '', bearer: 'bearer name' } }

        run_test! do
          errors = JSON.parse(response.body)['errors']

          expect(errors['name']).to eq([ErrorMessages.missing])
        end
      end
    end
  end

  path '/v1/stocks/{stock_id}' do
    patch 'updates stock' do
      tags 'Stocks'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :stock_id, in: :path, type: :string
      parameter name: :param, in: :body, schema: {
        type: :object,
        properties: {
          stock: {
            type: :object,
            properties: {
              name: { type: :string, example: 'new stock name' },
              bearer: { type: :string, example: 'new bearer name' }
            },
            required: %w[name bearer]
          }
        },
        required: %w[stock]
      }

      let(:param) { { stock: stock_params } }
      let!(:stock) { create(:stock) }
      let(:stock_id) { stock.id }
      let(:stock_params) { { name: 'name x', bearer: 'name y' } }

      response '200', 'updates medical_datum' do
        run_test! do
          stock.reload
          expect(stock.name).to eq(stock_params[:name])
          expect(stock.bearer.name).to eq(stock_params[:bearer])
        end
      end

      response '422', 'does not create new stock with duplicate name' do
        let(:old_stock) { create(:stock) }
        let(:stock_params) do
          {
            name: old_stock.name,
            bearer: 'new bearer'
          }
        end

        run_test! do
          errors = JSON.parse(response.body)['errors']

          expect(errors['name']).to eq([ErrorMessages.already_exists])
        end
      end

      response '422', 'invalid bearer param' do
        let(:stock_params) { { name: '', bearer: '' } }

        run_test! do
          errors = JSON.parse(response.body)['errors']

          expect(errors['bearer']).to eq([ErrorMessages.invalid_params])
        end
      end

      response '422', 'invalid stock param' do
        let(:stock_params) { { name: '', bearer: 'bearer name' } }

        run_test! do
          errors = JSON.parse(response.body)['errors']

          expect(errors['name']).to eq([ErrorMessages.missing])
        end
      end

      response '404', 'invalid stock id' do
        let(:stock_id) { stock.id + 1 }

        run_test!
      end
    end

    delete 'Soft deletes stock' do
      tags 'Stocks'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :stock_id, in: :path, type: :string
      let(:stock) { create(:stock) }
      let(:stock_id) { stock.id }

      response '200', 'soft deletes stock' do
        run_test! do
          expect(stock.reload.archived_at).not_to be_nil
        end
      end

      response '404', 'deleted stock cannot be deleted again' do
        let(:stock) { create(:stock, archived_at: 10.days.ago) }

        run_test! do
          expect(JSON.parse(response.body)['errors']['stock']).to eq([ErrorMessages.record_not_found])
        end
      end

      response '404', 'invalid stock id' do
        let(:stock_id) { stock.id + 1 }

        run_test!
      end
    end
  end
end
