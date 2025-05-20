# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::TextFieldAreaSetTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { instance_double(OmniAI::Tools::Browser::BaseDriver) }

  describe "#execute" do
    subject(:execute) { tool.execute(selector:, text:) }

    let(:selector) { "name" }
    let(:text) { "Ringo Starr" }

    it "proxies to the driver" do
      allow(driver).to receive(:fill_in).and_return({ status: :ok })
      execute
      expect(execute).to eql(status: :ok)
      expect(driver).to have_received(:fill_in).with(selector:, text:)
    end
  end
end
