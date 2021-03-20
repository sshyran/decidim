# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module HasUploadValidations
    extend ActiveSupport::Concern

    class_methods do
      def validates_upload(attribute, options = {})
        max_size = options[:max_size] || ->(record) { record.maximum_upload_size }

        validates(
          attribute,
          file_size: { less_than_or_equal_to: max_size },
          organization_present: true,
          uploader_content_type: true,
          uploader_image_dimensions: true
        )

        if block_given?
          attached_config[attribute] = OpenStruct.new(options)

          yield(attached_config[attribute])
        end
      end

      def validates_avatar(attribute = :avatar)
        validates_upload(
          attribute,
          max_size: ->(record) { record.maximum_avatar_size }
        )
      end

      def attached_config
        @attached_config ||= superclass.respond_to?(:attached_config) ? superclass.attached_config.dup : {}
      end

      def attached_options(attached, options = {})
        attached_config[attached] = OpenStruct.new(options)

        yield(attached_config[attached]) if block_given?
      end
    end

    delegate :attached_config, to: :class

    def attached_uploader(attached_name)
      return if (uploader = attached_config.dig(attached_name, :uploader)).blank?

      uploader.new(self)
    end

    def maximum_upload_size
      Decidim.organization_settings(organization).upload_maximum_file_size
    end

    def maximum_avatar_size
      Decidim.organization_settings(organization).upload_maximum_file_size_avatar
    end
  end
end
