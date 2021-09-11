# frozen_string_literal: true

module Archivable
  extend ActiveSupport::Concern
  included do
    scope :archived, -> { where.not(archived_at: nil) }
    scope :not_archived, -> { where(archived_at: nil) }

    def archive
      return if archived?

      update_columns archived_at: DateTime.now
    end

    def restore_from_archive
      return unless archived?

      update_columns archived_at: nil
    end

    def archived?
      archived_at.present?
    end
  end
end
