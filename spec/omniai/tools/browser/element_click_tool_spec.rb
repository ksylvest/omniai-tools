# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::ElementClickTool do
  subject(:tool) { described_class.new(browser:) }

  let(:browser) { instance_double(Watir::Browser) }
  let(:element) { instance_double(Watir::Element, exists?: exists) }

  describe "#execute" do
    subject(:execute) { tool.execute(selector:) }

    let(:selector) { "test-selector" }

    context "when the element exists by CSS selector" do
      let(:exists) { true }

      it "clicks the element found by CSS selector" do
        allow(browser).to receive(:element).with(css: selector).and_return(element)
        allow(browser).to receive(:element).with(text: selector).and_return(nil)
        allow(browser).to receive(:element).with(id: selector).and_return(nil)
        allow(browser).to receive(:element).with(xpath: selector).and_return(nil)
        allow(element).to receive(:click)

        expect(execute).to eq("Successfully clicked element with selector: #{selector}")
        expect(element).to have_received(:click)
      end
    end

    context "when the element exists by text" do
      let(:exists) { true }

      it "clicks the element found by text" do
        allow(browser).to receive(:element).with(css: selector).and_return(nil)
        allow(browser).to receive(:element).with(text: selector).and_return(element)
        allow(browser).to receive(:element).with(id: selector).and_return(nil)
        allow(browser).to receive(:element).with(xpath: selector).and_return(nil)
        allow(element).to receive(:click)

        expect(execute).to eq("Successfully clicked element with selector: #{selector}")
        expect(element).to have_received(:click)
      end
    end

    context "when the element exists by ID" do
      let(:exists) { true }

      it "clicks the element found by ID" do
        allow(browser).to receive(:element).with(css: selector).and_return(nil)
        allow(browser).to receive(:element).with(text: selector).and_return(nil)
        allow(browser).to receive(:element).with(id: selector).and_return(element)
        allow(browser).to receive(:element).with(xpath: selector).and_return(nil)
        allow(element).to receive(:click)

        expect(execute).to eq("Successfully clicked element with selector: #{selector}")
        expect(element).to have_received(:click)
      end
    end

    context "when the element exists by XPath" do
      let(:exists) { true }

      it "clicks the element found by XPath" do
        allow(browser).to receive(:element).with(css: selector).and_return(nil)
        allow(browser).to receive(:element).with(text: selector).and_return(nil)
        allow(browser).to receive(:element).with(id: selector).and_return(nil)
        allow(browser).to receive(:element).with(xpath: selector).and_return(element)
        allow(element).to receive(:click)

        expect(execute).to eq("Successfully clicked element with selector: #{selector}")
        expect(element).to have_received(:click)
      end
    end

    context "when the element does not exist" do
      let(:exists) { false }

      it "returns an error" do
        allow(browser).to receive(:element).with(css: selector).and_return(nil)
        allow(browser).to receive(:element).with(text: selector).and_return(nil)
        allow(browser).to receive(:element).with(id: selector).and_return(nil)
        allow(browser).to receive(:element).with(xpath: selector).and_return(nil)

        expect(execute).to eq({ error: "unknown selector=#{selector}" })
      end
    end

    context "when the XPath selector causes an exception" do
      let(:selector) { "//invalid[xpath" }

      it "handles the error gracefully" do
        allow(browser).to receive(:element).with(css: selector).and_return(nil)
        allow(browser).to receive(:element).with(text: selector).and_return(nil)
        allow(browser).to receive(:element).with(id: selector).and_return(nil)
        allow(browser).to receive(:element).with(xpath: selector).and_raise(StandardError.new("Invalid XPath expression"))

        expect(execute).to eq({ error: "unknown selector=#{selector}" })
      end
    end
  end
end
