# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::PageScreenshotTool do
  subject(:tool) { described_class.new(browser:) }

  let(:browser) { instance_double(Watir::Browser) }
  let(:screenshot) { instance_double(Watir::Screenshot) }
  let(:element) { instance_double(Watir::Element) }
  let(:base64_data) { "base64encodedscreenshotdata" }

  describe "#execute" do
    before do
      allow(browser).to receive(:screenshot).and_return(screenshot)
      allow(screenshot).to receive(:base64).and_return(base64_data)
    end

    context "with no parameters (full page screenshot)" do
      subject(:execute) { tool.execute }

      it "returns base64 encoded screenshot of the page" do
        expect(execute).to eq("data:image/png;base64,#{base64_data}")
        expect(browser).to have_received(:screenshot)
      end
    end

    context "with format parameter" do
      subject(:execute) { tool.execute(format: "jpeg") }

      it "returns screenshot with the specified format" do
        expect(execute).to eq("data:image/jpeg;base64,#{base64_data}")
      end
    end

    context "with full_page parameter" do
      subject(:execute) { tool.execute(full_page: true) }

      it "takes a full page screenshot" do
        expect(execute).to eq("data:image/png;base64,#{base64_data}")
      end
    end

    context "with selector parameter" do
      subject(:execute) { tool.execute(selector: ".my-element") }

      before do
        allow(browser).to receive(:element).with(css: ".my-element").and_return(element)
        allow(element).to receive(:exists?).and_return(true)
      end

      it "takes a screenshot of the specified element" do
        expect(execute).to eq("data:image/png;base64,#{base64_data}")
        expect(browser).to have_received(:element).with(css: ".my-element")
        expect(browser).to have_received(:screenshot)
      end
    end

    context "with selector that doesn't match any element" do
      subject(:execute) { tool.execute(selector: ".non-existent") }

      before do
        allow(browser).to receive(:element).with(css: ".non-existent").and_return(element)
        allow(element).to receive(:exists?).and_return(false)
      end

      it "returns an error message" do
        expect(execute).to eq("No element found matching selector: .non-existent")
      end
    end

    context "when screenshot fails" do
      subject(:execute) { tool.execute }

      before do
        allow(browser).to receive(:screenshot).and_raise(StandardError.new("Screenshot failed"))
      end

      it "returns an error message" do
        expect(execute).to eq("Error taking screenshot: Screenshot failed")
      end
    end

    context "when element screenshot fails" do
      subject(:execute) { tool.execute(selector: ".my-element") }

      before do
        allow(browser).to receive(:element).with(css: ".my-element").and_return(element)
        allow(element).to receive(:exists?).and_return(true)
        allow(browser).to receive(:screenshot).and_raise(StandardError.new("Element screenshot failed"))
      end

      it "returns an error message" do
        expect(execute).to eq("Error taking element screenshot: Element screenshot failed")
      end
    end
  end
end
