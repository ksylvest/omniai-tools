# frozen_string_literal: true

module OmniAI
  module Tools
    module Disk
      # @example
      #   tool = OmniAI::Tools::Disk::FileReadTool.new(root: "./project")
      #   tool.execute(
      #     old_text: 'puts "ABC"',
      #     new_text: 'puts "DEF"',
      #     path: "README.md"
      #   )
      class FileReplaceTool < BaseTool
        description "Replaces a specific string in a file (old_text => new_text)."

        parameter :old_text, :string, description: "the old text (e.g. `puts 'ABC'`)"
        parameter :new_text, :string, description: "the new text (e.g. `puts 'DEF'`)"
        parameter :path, :string, description: "a path (e.g. `./main.rb`)"

        required %i[old_text new_text path]

        # @param path [String]
        # @param old_text [String]
        # @param new_text [String]
        def execute(old_text:, new_text:, path:)
          @logger.info %(#{self.class.name}#execute old_text="#{old_text}" new_text="#{new_text}" path="#{path}")
          @driver.file_replace(old_text:, new_text:, path:)
        rescue SecurityError => e
          @logger.error(e.message)
          raise e
        end
      end
    end
  end
end
