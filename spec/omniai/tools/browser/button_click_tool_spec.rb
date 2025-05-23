# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::ButtonClickTool do
  subject(:tool) { described_class.new(browser:) }

  let(:browser) { instance_double(Watir::Browser) }
  let(:button) { instance_double(Watir::Button, exists?: exists) }

  describe "#execute" do
    subject(:execute) { tool.execute(selector:) }

    let(:selector) { "Hello World" }

    context "when the button exists by text" do
      let(:exists) { true }

      it "clicks the button found by text" do
        allow(browser).to receive(:button).with(text: selector).and_return(button)
        allow(browser).to receive(:button).with(id: selector).and_return(nil)
        allow(button).to receive(:click)

        expect(execute).to eq("Successfully clicked button with selector: #{selector}")
        expect(button).to have_received(:click)
      end
    end

    context "when the button exists by id" do
      let(:exists) { true }

      it "clicks the button found by id" do
        allow(browser).to receive(:button).with(text: selector).and_return(nil)
        allow(browser).to receive(:button).with(id: selector).and_return(button)
        allow(button).to receive(:click)

        expect(execute).to eq("Successfully clicked button with selector: #{selector}")
        expect(button).to have_received(:click)
      end
    end

    context "when the button does not exist" do
      let(:exists) { false }

      it "returns an error" do
        allow(browser).to receive(:button).with(text: selector).and_return(button)
        allow(browser).to receive(:button).with(id: selector).and_return(nil)
        allow(button).to receive(:click)

        expect(execute).to eq({ error: "unknown selector=#{selector}" })
        expect(button).not_to have_received(:click)
      end
    end
  end
end
