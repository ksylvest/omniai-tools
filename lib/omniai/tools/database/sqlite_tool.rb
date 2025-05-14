# frozen_string_literal: true

require "sqlite3"

module OmniAI
  module Tools
    module Database
      # @example
      #   tool = OmniAI::Tools::Database::SqliteTool.new
      #   tool.execute(path: "./foo/bar")
      class SqliteTool < BaseTool
        description <<~TEXT
          Executes SQL commands (INSERT / UPDATE / SELECT / etc) on a database.

          Example:

          STATEMENTS:

              [
                'CREATE TABLE people (id INTEGER PRIMARY KEY, name TEXT NOT NULL)',
                'INSERT INTO people (name) VALUES ('John')',
                'INSERT INTO people (name) VALUES ('Paul')',
                'SELECT * FROM people',
                'DROP TABLE people'
              ]

          RESULT:

              [
                {
                  "status": "OK",
                  "statement": "CREATE TABLE people (id INTEGER PRIMARY KEY, name TEXT NOT NULL)",
                  "result": "..."
                },
                {
                  "status": "OK",
                  "statement": "INSERT INTO people (name) VALUES ('John')"
                  "result": "..."
                },
                {
                  "status": "OK",
                  "statement": "INSERT INTO people (name) VALUES ('Paul')",
                  "result": "..."
                },
                {
                  "status": "OK",
                  "statement": "SELECT * FROM people",
                  "result": "..."
                },
                {
                  "status": "OK",
                  "statement": "DROP TABLE people",
                  "result": "..."
                }
              ]
        TEXT

        parameter(
          :statements,
          :array,
          description: "A list of SQL statements to run sequentially.",
          items: OmniAI::Schema.string(description: 'A SQL statement to run (e.g. "SELECT * FROM ...").')
        )

        required %i[statements]

        # @param logger [IO] An optional logger for debugging executed commands.
        # @param db [SQLite3::Database] A sqlite database.
        def initialize(db:, logger: Logger.new(IO::NULL))
          super(logger:)
          @db = db
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

      protected

        # @param statement [String]
        #
        # @return [Hash]
        def perform(statement:)
          @logger.info(%(#{self.class.name}#perform statement=#{statement.inspect}))

          result = @db.execute2(statement)

          { status: :ok, statement:, result: }
        rescue ::SQLite3::Exception => e
          @logger.warn("ERROR: #{e.message}")

          { status: :error, statement:, result: e.message }
        end
      end
    end
  end
end
