# frozen_string_literal: true

module OmniAI
  module Tools
    module Disk
      # @example
      #   tool = OmniAI::Tools::Disk::DirectoryCreateTool.new(root: "./project")
      #   tool.execute(path: "./foo/bar")
      class DirectoryCreateTool < BaseTool
        description "Creates a directory."

        parameter :old_path, :string, description: "a path (e.g. `./old`)"
        parameter :new_path, :string, description: "a path (e.g. `./new`)"

        required %i[old_path new_path]

        # @param old_path [String]
        # @param new_path [String]
        #
        # @return [String]
        def execute(old_path:, new_path:)
          @logger.info("#{self.class.name}#execute path=#{path.inspect}")

          FileUtils.mv(old_path, new_path)
        rescue SecurityError => e
          @logger.error(e.message)
          raise e
        end
      end
    end
  end
end
