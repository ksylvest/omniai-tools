# frozen_string_literal: true

module OmniAI
  module Tools
    module Disk
      # @example
      #   tool = OmniAI::Tools::Disk::SummaryTool.new(root: "./project")
      #   tool.execute
      class DirectoryListTool < BaseTool
        description "Summarizes the contents (files and directories) of a directory."

        parameter :path, :string, description: "a path to the directory (e.g. `./foo/bar`)"

        required %i[path]

        # @return [String]
        def execute(path: ".")
          @logger.info("#{self.class.name}#execute")

          @driver.directory_list(path:)
        rescue SecurityError => e
          @logger.error(e.message)
          raise e
        end
      end
    end
  end
end
