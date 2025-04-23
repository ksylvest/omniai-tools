# frozen_string_literal: true

module OmniAI
  module Tools
    module Disk
      # @example
      #   tool = OmniAI::Tools::Disk::FileMoveTool.new(root: "./project")
      #   tool.execute(
      #     old_path: "./README.txt",
      #     new_path: "./README.md",
      #   )
      class FileMoveTool < BaseTool
        description "Moves a file."

        parameter :old_path, :string, description: "a path (e.g. `./old.rb`)"
        parameter :new_path, :string, description: "a path (e.g. `./new.rb`)"

        required %i[old_path new_path]

        # @param old_path [String]
        # @param new_path [String]
        #
        # @return [String]
        def execute(old_path:, new_path:)
          @logger.info("#{self.class.name}#execute old_path=#{old_path.inspect} new_path=#{new_path.inspect}")

          FileUtils.mv(
            resolve!(path: old_path),
            resolve!(path: new_path)
          )
        rescue SecurityError => e
          @logger.info("ERROR: #{e.message}")
          raise e
        end
      end
    end
  end
end
