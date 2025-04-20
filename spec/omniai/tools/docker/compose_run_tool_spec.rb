# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Docker::ComposeRunTool do
  subject(:tool) { described_class.new(root:) }

  let(:root) { ROOT.join("spec", "fixtures", "project") }

  describe "#execute" do
    subject(:execute) { tool.execute(command: "rspec", args: %w[./spec]) }

    context "when the command works" do
      let(:status) { instance_double(Process::Status, exitstatus: 0, success?: true) }

      it "returns the text" do
        allow(Open3).to receive(:capture2e).and_return(["OK!", status])

        expect(execute).to eq("OK!")

        expect(Open3).to have_received(:capture2e)
          .with("docker", "compose", "run", "--build", "--rm", "app", "rspec", "./spec")
      end
    end

    context "when the command fails" do
      let(:status) { instance_double(Process::Status, exitstatus: 9, success?: false) }

      it "returns the text" do
        allow(Open3).to receive(:capture2e).and_return(["Whoops!", status])

        expect(execute).to eq("ERROR: [STATUS=9] Whoops!")

        expect(Open3).to have_received(:capture2e)
          .with("docker", "compose", "run", "--build", "--rm", "app", "rspec", "./spec")
      end
    end
  end
end
