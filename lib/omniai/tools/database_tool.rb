# frozen_string_literal: true

module OmniAI
  module Tools
    # @example
    #   db = Sqlite3::Database.new("./db.sqlite")
    #   driver = OmniAI::Tools::Database::Sqlite.new(db:)
    #   tool = OmniAI::Tools::DatabaseTool.new(driver:)
    #   tool.execute(statements: ["SELECT * FROM people"])
    class DatabaseTool < OmniAI::Tool
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

      # @param driver [OmniAI::Tools::Database::BaseDriver]
      # @param logger [IO] An optional logger for debugging executed commands.
      def initialize(driver:, logger: Logger.new(IO::NULL))
        super()
        @driver = driver
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
            execution = perform(statement:).merge(statement:)
            executions << execution
            break unless execution[:status].eql?(:ok)
          end
        end
      end

      def perform(statement:)
        @logger&.info("#perform statement=#{statement.inspect}")

        @driver.perform(statement:).tap do |result|
          @logger&.info(JSON.generate(result))
        end
      end
    end
  end
end
