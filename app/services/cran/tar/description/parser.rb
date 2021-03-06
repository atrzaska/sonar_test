# frozen_string_literal: true

module Cran
  module Tar
    module Description
      class Parser
        attr_reader :metadata

        include Service

        def initialize(metadata)
          @metadata = metadata
        end

        def call
          results = {}
          field = nil
          value = ''

          metadata.lines.each do |line|
            if line.start_with?("\t") || line.start_with?('  ')
              value += ' ' if value.present?
              value += line.squish
            else
              results[field] = value if field

              field = line.partition(': ').first
              value = line.partition(': ')[2..].join.squish.gsub("\n", '')
            end
          end

          results[field] = value if field

          results
        end
      end
    end
  end
end
