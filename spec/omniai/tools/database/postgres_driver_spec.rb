# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Database::PostgresDriver do
  subject(:driver) { described_class.new(connection:) }

  let(:connection) { instance_double(PG::Connection) }

  describe "#perform" do
    subject(:perform) { driver.perform(statement:) }

    let(:result) { instance_double(PG::Result, fields: ["name"], values: [["John"], ["Paul"], ["George"], ["Ringo"]]) }

    context "with a valid statement" do
      let(:statement) { "SELECT * FROM people" }

      it "executes the statement and returns the result as a hash" do
        allow(connection).to receive(:exec).with("SELECT * FROM people").and_yield(result)

        expect(perform).to eq({ status: :ok, result: [["name"], ["John"], ["Paul"], ["George"], ["Ringo"]] })
      end
    end

    context "with an invalid statement" do
      let(:statement) { "SELECT *" }

      it "rescues from PG::Error and returns an error message" do
        allow(connection).to receive(:exec).with("SELECT *").and_raise(PG::Error.new("Whoops!"))

        expect(perform).to eq({ status: :error, message: "Whoops!" })
      end
    end
  end
end
