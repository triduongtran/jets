# frozen_string_literal: true

module Jets
  module Command
    class NotesCommand < Base # :nodoc:
      class_option :annotations, aliases: "-a", desc: "Filter by specific annotations, e.g. Foobar TODO", type: :array

      def perform(*)
        require_application_and_environment!

        # lazy require so Rails const is only defined when using notes
        require "rails/source_annotation_extractor"

        display_annotations
      end

      private
        def display_annotations
          annotations = options[:annotations] || Rails::SourceAnnotationExtractor::Annotation.tags
          tag = (annotations.length > 1)

          Rails::SourceAnnotationExtractor.enumerate annotations.join("|"), tag: tag, dirs: directories
        end

        def directories
          Rails::SourceAnnotationExtractor::Annotation.directories
        end
    end
  end
end
