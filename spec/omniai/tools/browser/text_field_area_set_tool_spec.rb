# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::TextFieldAreaSetTool do
  subject(:tool) { described_class.new(browser:) }

  let(:browser) { instance_double(Watir::Browser) }
  let(:text_field) { instance_double(Watir::TextField) }
  let(:text_area) { instance_double(Watir::TextArea) }

  describe "#execute" do
    subject(:execute) { tool.execute(selector:, text:) }

    let(:selector) { "name" }
    let(:text) { "Ringo Starr" }

    context "with a text area by id" do
      it "fills in the text area" do
        allow(browser).to receive(:textarea).with(id: selector).and_return(text_area)
        allow(browser).to receive(:textarea).with(name: selector).and_return(nil)
        allow(browser).to receive(:text_field).with(id: selector).and_return(nil)
        allow(browser).to receive(:text_field).with(name: selector).and_return(nil)

        allow(text_area).to receive(:exists?).and_return(true)
        allow(text_area).to receive(:set)

        expect(execute).to eq("Successfully set text for input with selector: #{selector}")
        expect(text_area).to have_received(:set).with(text)
      end
    end

    context "with a text area by name" do
      it "fills in the text area" do
        allow(browser).to receive(:textarea).with(id: selector).and_return(nil)
        allow(browser).to receive(:textarea).with(name: selector).and_return(text_area)
        allow(browser).to receive(:text_field).with(id: selector).and_return(nil)
        allow(browser).to receive(:text_field).with(name: selector).and_return(nil)

        allow(text_area).to receive(:exists?).and_return(true)
        allow(text_area).to receive(:set)

        expect(execute).to eq("Successfully set text for input with selector: #{selector}")
        expect(text_area).to have_received(:set).with(text)
      end
    end

    context "with a text field by id" do
      it "fills in the text field" do
        allow(browser).to receive(:textarea).with(id: selector).and_return(nil)
        allow(browser).to receive(:textarea).with(name: selector).and_return(nil)
        allow(browser).to receive(:text_field).with(id: selector).and_return(text_field)
        allow(browser).to receive(:text_field).with(name: selector).and_return(nil)

        allow(text_field).to receive(:exists?).and_return(true)
        allow(text_field).to receive(:set)

        expect(execute).to eq("Successfully set text for input with selector: #{selector}")
        expect(text_field).to have_received(:set).with(text)
      end
    end

    context "with a text field by name" do
      it "fills in the text field" do
        allow(browser).to receive(:textarea).with(id: selector).and_return(nil)
        allow(browser).to receive(:textarea).with(name: selector).and_return(nil)
        allow(browser).to receive(:text_field).with(id: selector).and_return(nil)
        allow(browser).to receive(:text_field).with(name: selector).and_return(text_field)

        allow(text_field).to receive(:exists?).and_return(true)
        allow(text_field).to receive(:set)

        expect(execute).to eq("Successfully set text for input with selector: #{selector}")
        expect(text_field).to have_received(:set).with(text)
      end
    end

    context "with neither a text field nor a text area" do
      it "returns an error" do
        allow(browser).to receive(:textarea).with(id: selector).and_return(text_area)
        allow(browser).to receive(:textarea).with(name: selector).and_return(nil)
        allow(browser).to receive(:text_field).with(id: selector).and_return(nil)
        allow(browser).to receive(:text_field).with(name: selector).and_return(nil)

        allow(text_area).to receive(:exists?).and_return(false)

        expect(execute).to eq({ error: "unknown selector=#{selector}" })
      end
    end
  end
end
