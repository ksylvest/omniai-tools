# frozen_string_literal: true

module OmniAI
  module Tools
    module Disk
      # @example
      #   tool = OmniAI::Tools::Disk::FileMoveTool.new(root: "./project")
      #   tool.execute(
      #     path: "./README.txt",
      #     destination: "./README.md",
      #   )
      class FileMoveTool < BaseTool
        description "Moves a file."

        parameter :path, :string, description: "a path (e.g. `./old.rb`)"
        parameter :destination, :string, description: "a path (e.g. `./new.rb`)"

        required %i[path destination]

        # @param path [String]
        # @param destination [String]
        #
        # @return [String]
        def execute(path:, destination:)
          @logger.info("#{self.class.name}#execute path=#{path.inspect} destination=#{destination.inspect}")
          @driver.file_move(path:, destination:)
        rescue SecurityError => e
          @logger.info("ERROR: #{e.message}")
          raise e
        end
      end
    end
  end
end
