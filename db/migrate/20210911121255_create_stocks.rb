# frozen_string_literal: true

class CreateStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :stocks do |t|
      t.string :name
      t.integer :bearer_id
      t.datetime :archived_at

      t.timestamps
    end
    add_index :stocks, :bearer_id
  end
end
