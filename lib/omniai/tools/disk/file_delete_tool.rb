# frozen_string_literal: true

module OmniAI
  module Tools
    module Disk
      # @example
      #   tool = OmniAI::Tools::Disk::FileDeleteTool.new(root: "./project")
      #   tool.execute(path: "./README.md")
      class FileDeleteTool < BaseTool
        description "Deletes a file."

        parameter :path, :string, description: "a path to the file (e.g. `./README.md`)"

        required %i[path]

        # @param path [String]
        #
        # @raise [SecurityError]
        #
        # @return [String]
        def execute(path:)
          @logger.info("#{self.class.name}#execute path=#{path.inspect}")
          @driver.file_delete(path:)
        rescue SecurityError => e
          @logger.error(e.message)
          raise e
        end
      end
    end
  end
end
