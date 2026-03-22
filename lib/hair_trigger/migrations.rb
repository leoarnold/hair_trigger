require 'prism'

module HairTrigger
  module Migrations
    autoload :SnippetExtractor, 'hair_trigger/migrations/snippet_extractor'
    autoload :SyntaxVisitor, 'hair_trigger/migrations/syntax_visitor'
  end
end
