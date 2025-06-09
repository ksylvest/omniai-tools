# frozen_string_literal: true

module OmniAI
  module Tools
    module Disk
      # @example
      #   tool = OmniAI::Tools::Disk::DirectoryMoveTool.new(root: "./project")
      #   tool.execute(path: "./foo", destination: "./bar")
      class DirectoryMoveTool < BaseTool
        description "Moves a directory from one location to another."

        parameter :path, :string, description: "a path (e.g. `./old`)"
        parameter :destination, :string, description: "a path (e.g. `./new`)"

        required %i[path destination]

        # @param path [String]
        # @param destination [String]
        #
        # @return [String]
        def execute(path:, destination:)
          @logger.info("#{self.class.name}#execute path=#{path.inspect} destination=#{destination.inspect}")
          @driver.directory_move(path:, destination:)
        rescue SecurityError => e
          @logger.error(e.message)
          raise e
        end
      end
    end
  end
end
