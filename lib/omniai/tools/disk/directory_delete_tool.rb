# frozen_string_literal: true

module OmniAI
  module Tools
    module Disk
      # @example
      #   tool = OmniAI::Tools::Disk::DirectoryDeleteTool.new(root: "./project")
      #   tool.execute(path: "./foo/bar")
      class DirectoryDeleteTool < BaseTool
        description "Deletes a directory."

        parameter :path, :string, description: "a path to the directory (e.g. `./foo/bar`)"

        required %i[path]

        # @param path [String]
        #
        # @return [String]
        def execute(path:)
          @logger.info("#{self.class.name}#execute path=#{path.inspect}")

          FileUtils.rmdir(resolve!(path:))
        rescue SecurityError => e
          @logger.error(e.message)
          raise e
        end
      end
    end
  end
end
