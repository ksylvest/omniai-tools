# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::VisitTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { instance_double(OmniAI::Tools::Browser::BaseDriver) }

  describe "#execute" do
    subject(:execute) { tool.execute(url:) }

    let(:url) { "https://news.ycombinator.com" }

    it "proxies to the driver" do
      allow(driver).to receive(:goto).and_return({ status: :ok })
      execute
      expect(execute).to eql(status: :ok)
      expect(driver).to have_received(:goto).with(url:)
    end
  end
end
