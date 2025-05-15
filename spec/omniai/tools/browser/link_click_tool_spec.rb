# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::LinkClickTool do
  subject(:tool) { described_class.new(browser:) }

  let(:browser) { instance_double(Watir::Browser) }
  let(:link) { instance_double(Watir::Anchor, exists?: exists) }

  describe "#execute" do
    subject(:execute) { tool.execute(selector:) }

    let(:selector) { "Hello World" }

    context "with the button exists" do
      let(:exists) { true }

      it "clicks the buttton" do
        allow(browser).to receive(:a).and_return(link)
        allow(link).to receive(:click)
        expect(execute).to be_nil
        expect(link).to have_received(:click)
      end
    end

    context "with the button does not exist" do
      let(:exists) { false }

      it "returns an error" do
        allow(browser).to receive(:a).and_return(link)
        allow(link).to receive(:click)
        expect(execute).to eq({ error: "unknown selector=#{selector}" })
        expect(link).not_to have_received(:click)
      end
    end
  end
end
