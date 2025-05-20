# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::PageScreenshotTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { instance_double(OmniAI::Tools::Browser::BaseDriver) }

  let(:data) { "..." }

  describe "#execute" do
    subject(:execute) { tool.execute }

    it "proxies to the driver" do
      allow(driver).to receive(:screenshot).and_yield(instance_double(File, read: data))
      result = execute
      expect(result).to eql("data:image/png;base64,#{Base64.strict_encode64(data)}")
      expect(driver).to have_received(:screenshot)
    end
  end
end
