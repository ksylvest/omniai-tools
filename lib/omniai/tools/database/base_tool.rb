# frozen_string_literal: true

require "sqlite3"

module OmniAI
  module Tools
    module Database
      # @example
      #   tool = OmniAI::Tools::Database::SqliteTool.new
      #   tool.execute(path: "./foo/bar")
      class BaseTool < OmniAI::Tool
        # @param logger [IO] An optional logger for debugging executed commands.
        def initialize(logger: Logger.new(IO::NULL))
          super()
          @logger = logger
        end

        # @example
        #   tool = OmniAI::Tools::Database::BaseTool.new
        #   tool.execute(statements: ["SELECT * FROM people"])
        #
        # @param statements [Array<String>]
        #
        # @return [Array<Hash>]
        def execute(statements:)
          [].tap do |executions|
            statements.map do |statement|
              execution = perform(statement:)
              executions << execution
              break unless execution[:status].eql?(:ok)
            end
          end
        end
      end
    end
  end
end
