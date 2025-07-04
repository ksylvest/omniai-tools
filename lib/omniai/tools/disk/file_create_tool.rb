# frozen_string_literal: true

module OmniAI
  module Tools
    module Disk
      # @example
      #   tool = OmniAI::Tools::Disk::FileCreateTool.new(root: "./project")
      #   tool.execute(path: "./README.md")
      class FileCreateTool < BaseTool
        description "Creates a file."

        parameter :path, :string, description: "a path to the file (e.g. `./README.md`)"

        required %i[path]

        # @param path [String]
        #
        # @return [String]
        def execute(path:)
          @logger.info("#{self.class.name}#execute path=#{path.inspect}")
          @driver.file_create(path:)
        rescue SecurityError => e
          @logger.error(e.message)
          raise e
        end
      end
    end
  end
end
