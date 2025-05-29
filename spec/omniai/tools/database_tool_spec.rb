# frozen_string_literal: true

RSpec.describe OmniAI::Tools::DatabaseTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { OmniAI::Tools::Database::SqliteDriver.new(db:) }
  let(:db) { SQLite3::Database.new(":memory:") }

  describe "#execute" do
    subject(:execute) { tool.execute(statements:) }

    let(:statements) do
      [
        "CREATE TABLE people (id INTEGER PRIMARY KEY, name TEXT)",
        "INSERT INTO people (name) VALUES ('John')",
        "INSERT INTO people (name) VALUES ('Paul')",
        "SELECT * FROM people",
        "SELECT * FROM places",
      ]
    end

    it "runs the SQL statements" do
      expect(execute).to eql([
        {
          status: :ok,
          statement: "CREATE TABLE people (id INTEGER PRIMARY KEY, name TEXT)",
          result: [[]],
        },
        {
          status: :ok,
          statement: "INSERT INTO people (name) VALUES ('John')",
          result: [[]],
        },
        {
          status: :ok,
          statement: "INSERT INTO people (name) VALUES ('Paul')",
          result: [[]],
        },
        {
          status: :ok,
          statement: "SELECT * FROM people",
          result: [
            %w[id name],
            [1, "John"],
            [2, "Paul"],
          ],
        },
        {
          status: :error,
          statement: "SELECT * FROM places",
          message: "no such table: places:\nSELECT * FROM places",
        },
      ])
    end
  end
end
