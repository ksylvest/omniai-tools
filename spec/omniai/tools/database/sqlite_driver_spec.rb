# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Database::SqliteDriver do
  subject(:driver) { described_class.new(db:) }

  let(:db) { instance_double(SQLite3::Database) }

  describe "#perform" do
    subject(:perform) { driver.perform(statement:) }

    let(:result) { [["name"], ["John"], ["Paul"], ["George"], ["Ringo"]] }

    context "with a valid statement" do
      let(:statement) { "SELECT * FROM people" }

      it "executes the statement and returns the result as a hash" do
        allow(db).to receive(:execute2).with("SELECT * FROM people").and_return(result)

        expect(perform).to eq({ status: :ok, result: [["name"], ["John"], ["Paul"], ["George"], ["Ringo"]] })
      end
    end

    context "with an invalid statement" do
      let(:statement) { "SELECT *" }

      it "rescues from Sqlite3::SQLException and returns an error message" do
        allow(db).to receive(:execute2).with("SELECT *").and_raise(SQLite3::SQLException.new("Whoops!"))

        expect(perform).to eq({ status: :error, message: "Whoops!" })
      end
    end
  end
end
