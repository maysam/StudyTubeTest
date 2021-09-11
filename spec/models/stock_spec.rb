# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stock, type: :model do
  it { should belong_to(:bearer) }
  it { is_expected.to validate_presence_of(:name).with_message(ErrorMessages.missing) }
  it { is_expected.to validate_uniqueness_of(:name).with_message(ErrorMessages.already_exists) }
end
