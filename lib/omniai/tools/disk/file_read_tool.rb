# frozen_string_literal: true

module OmniAI
  module Tools
    module Disk
      # @example
      #   tool = OmniAI::Tools::Disk::FileReadTool.new(root: "./project")
      #   tool.execute(path: "./README.md") # => "..."
      class FileReadTool < BaseTool
        description "reads the contents of a file"

        parameter :path, :string, description: "a path (e.g. `./main.rb`)"

        required %i[path]

        # @param path [String]
        #
        # @return [String]
        def execute(path:)
          @logger.info("#{self.class.name}#execute path=#{path}")
          File.read(resolve!(path:))
        rescue StandardError => e
          @logger.error(e.message)
          raise e
        end
      end
    end
  end
end
