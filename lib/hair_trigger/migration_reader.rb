module HairTrigger
  module MigrationReader
    class << self
      def get_triggers(source, options)
        snippets = if source.is_a?(String)
                     # schema.rb contents... because it's auto-generated and we know
                     # exactly what it will look like, we can safely use a regex
                     source.scan(/^  create_trigger\(.*?\n  end\n\n/m)
                   else
                     Migrations::SnippetExtractor.new(source).snippets
                   end

        snippets.filter_map do |snippet|
          trigger = instance_eval("generate_" + snippet.strip)
          trigger if options[:include_manual_triggers] || trigger.options[:generated]
        end
      rescue => e
        $stderr.puts "Error reading triggers in #{source.filename rescue "schema.rb"}: #{e}"

        []
      end

      private

      def generate_create_trigger(*arguments)
        arguments.unshift({}) if arguments.empty?
        arguments.unshift(nil) if arguments.first.is_a?(Hash)
        arguments.push({}) if arguments.size == 1
        arguments[1][:compatibility] ||= HairTrigger::Builder.base_compatibility
        ::HairTrigger::Builder.new(*arguments)
      end

      def generate_drop_trigger(*arguments)
        options = arguments[2] || {}
        ::HairTrigger::Builder.new(arguments[0], options.update({:table => arguments[1], :drop => true}))
      end
    end
  end
end
