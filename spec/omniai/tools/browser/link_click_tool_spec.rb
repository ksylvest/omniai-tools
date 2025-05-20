# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::LinkClickTool do
  subject(:tool) { described_class.new(browser:) }

  let(:browser) { instance_double(Watir::Browser) }
  let(:link) { instance_double(Watir::Anchor, exists?: exists) }

  describe "#execute" do
    subject(:execute) { tool.execute(selector:) }

    let(:selector) { "Hello World" }

    context "when the link exists by text" do
      let(:exists) { true }

      it "clicks the link found by text" do
        allow(browser).to receive(:a).with(text: selector).and_return(link)
        allow(browser).to receive(:a).with(value: selector).and_return(nil)
        allow(browser).to receive(:a).with(id: selector).and_return(nil)
        allow(link).to receive(:click)

        expect(execute).to eq("Successfully clicked link with selector: #{selector}")
        expect(link).to have_received(:click)
      end
    end

    context "when the link exists by value" do
      let(:exists) { true }

      it "clicks the link found by value" do
        allow(browser).to receive(:a).with(text: selector).and_return(nil)
        allow(browser).to receive(:a).with(value: selector).and_return(link)
        allow(browser).to receive(:a).with(id: selector).and_return(nil)
        allow(link).to receive(:click)

        expect(execute).to eq("Successfully clicked link with selector: #{selector}")
        expect(link).to have_received(:click)
      end
    end

    context "when the link exists by id" do
      let(:exists) { true }

      it "clicks the link found by id" do
        allow(browser).to receive(:a).with(text: selector).and_return(nil)
        allow(browser).to receive(:a).with(value: selector).and_return(nil)
        allow(browser).to receive(:a).with(id: selector).and_return(link)
        allow(link).to receive(:click)

        expect(execute).to eq("Successfully clicked link with selector: #{selector}")
        expect(link).to have_received(:click)
      end
    end

    context "when the link does not exist" do
      let(:exists) { false }

      it "returns an error" do
        allow(browser).to receive(:a).with(text: selector).and_return(link)
        allow(browser).to receive(:a).with(value: selector).and_return(nil)
        allow(browser).to receive(:a).with(id: selector).and_return(nil)
        allow(link).to receive(:click)

        expect(execute).to eq({ error: "unknown selector=#{selector}" })
        expect(link).not_to have_received(:click)
      end
    end
  end
end
