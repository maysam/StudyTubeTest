# frozen_string_literal: true

class ErrorMessages
  class << self
    def not_found
      'NOT_FOUND'
    end

    def resource_not_found
      'RESOURCE_NOT_FOUND'
    end

    def record_invalid
      'RECORD_INVALID'
    end

    def record_not_found
      'RECORD_NOT_FOUND'
    end

    def missing
      'MISSING'
    end

    def missing_params
      'MISSING_PARAMETERS'
    end

    def invalid_params
      'INVALID_PARAMETERS'
    end

    def name_already_exists
      'ALREADY_EXISTS'
    end

    def stock_updated
      'STOCK_UPDATED'
    end
  end
end
