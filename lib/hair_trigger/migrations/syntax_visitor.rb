module HairTrigger
  module Migrations
    class SyntaxVisitor < Prism::Visitor
      attr_reader :trigger_nodes

      def initialize(source_name)
        @source_name = source_name.to_sym

        @inside_target_class = false
        @inside_up_method = false

        @trigger_nodes = []
      end

      def visit_class_node(node)
        class_name = node.constant_path.slice
        return unless class_name.to_sym == @source_name

        @inside_target_class = true
        super
        @inside_target_class = false
      end

      def visit_def_node(node)
        return unless @inside_target_class
        return unless node.name == :up

        @inside_up_method = true
        super
        @inside_up_method = false
      end

      alias visit_defs_node visit_def_node

      def visit_call_node(node)
        return unless @inside_up_method
        return super unless trigger_node?(node)

        @trigger_nodes << node
      end

      private

      def trigger_node?(node)
        return false unless node.is_a?(Prism::CallNode)

        [:create_trigger, :drop_trigger].include?(node.name) || trigger_node?(node.receiver)
      end
    end
  end
end
