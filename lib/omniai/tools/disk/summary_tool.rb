# frozen_string_literal: true

module OmniAI
  module Tools
    module Disk
      # @example
      #   tool = OmniAI::Tools::Disk::SummaryTool.new(root: "./project")
      #   tool.execute
      class SummaryTool < BaseTool
        description "Summarize the contents (files and directories) of the project."

        # @return [String]
        def execute
          @logger.info("#{self.class.name}#execute")

          Dir.chdir(@root) do
            summary = Dir.glob("**/*").map { |path| summarize(path:) }.join("\n")
            @logger.debug(summary)
            summary
          end
        end

      private

        # @param path [String]
        def summarize(path:)
          if File.directory?(path)
            "📁 ./#{path}/"
          else
            "📄 ./#{path} (#{File.size(path)} bytes)"
          end
        end
      end
    end
  end
end
