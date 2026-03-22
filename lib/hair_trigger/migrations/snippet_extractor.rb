module HairTrigger
  module Migrations
    class SnippetExtractor
      class ExtractionError < Error; end

      attr_reader :snippets

      def initialize(source)
        @source = source
        @snippets = extract
      end

      private

      def extract
        contents = File.read(@source.filename)
        return [] unless contents =~ /(create|drop)_trigger/

        result = Prism.parse(contents)
        raise ExtractionError, result.errors.map(&:message).join("\n") unless result.success?

        visitor = SyntaxVisitor.new(@source.name)
        visitor.visit(result.value)

        visitor.trigger_nodes.map { |node| node.location.slice }
      end
    end
  end
end
