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

    before { allow(browser).to receive(:textarea).and_return(text_area) }
    before { allow(browser).to receive(:text_field).and_return(text_field) }

    context "with a text area" do
      it "fills in the text field" do
        allow(text_area).to receive(:exists?).and_return(true)
        allow(text_field).to receive(:exists?).and_return(false)
        allow(text_area).to receive(:set)
        expect(execute).to be_nil
        expect(text_area).to have_received(:set).with(text)
      end
    end

    context "with a text field" do
      it "fills in the text field" do
        allow(text_area).to receive(:exists?).and_return(false)
        allow(text_field).to receive(:exists?).and_return(true)
        allow(text_field).to receive(:set)
        expect(execute).to be_nil
        expect(text_field).to have_received(:set).with(text)
      end
    end

    context "with neither a text field nor a text area" do
      it "returns an error" do
        allow(text_area).to receive(:exists?).and_return(false)
        allow(text_field).to receive(:exists?).and_return(false)
        expect(execute).to eq({ error: "unknown selector=#{selector}" })
      end
    end
  end
end
