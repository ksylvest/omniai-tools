# frozen_string_literal: true

module OmniAI
  module Tools
    module Disk
      # @example
      #    tool = OmniAI::Tools::Disk::FileWriteTool.new(root: "./project")
      #    tool.execute(path: "./README.md", text: "Hello World")
      class FileWriteTool < BaseTool
        description "Writes the contents of a file."

        parameter :path, :string, description: "a path for the file (e.g. `./main.rb`)"
        parameter :text, :string, description: "the text to write to the file (e.g. `puts 'Hello World'`)"

        required %i[path text]

        # @param path [String]
        # @param text [String]
        #
        # @return [String]
        def execute(path:, text:)
          @logger.info("#{self.class.name}#execute path=#{path}")
          File.write(resolve!(path:), text)
        rescue StandardError => e
          @logger.error("ERROR: #{e.message}")
          raise e
        end
      end
    end
  end
end
