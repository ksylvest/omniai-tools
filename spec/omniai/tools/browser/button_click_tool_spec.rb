# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::ButtonClickTool do
  subject(:tool) { described_class.new(browser:) }

  let(:browser) { instance_double(Watir::Browser) }
  let(:button) { instance_double(Watir::Button, exists?: exists) }

  describe "#execute" do
    subject(:execute) { tool.execute(selector:) }

    let(:selector) { "Hello World" }

    context "with the button exists" do
      let(:exists) { true }

      it "clicks the buttton" do
        allow(browser).to receive(:button).and_return(button)
        allow(button).to receive(:click)
        expect(execute).to be_nil
        expect(button).to have_received(:click)
      end
    end

    context "with the button does not exist" do
      let(:exists) { false }

      it "returns an error" do
        allow(browser).to receive(:button).and_return(button)
        allow(button).to receive(:click)
        expect(execute).to eq({ error: "unknown selector=#{selector}" })
        expect(button).not_to have_received(:click)
      end
    end
  end
end
