# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::ClickTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { instance_double(OmniAI::Tools::Browser::BaseDriver) }

  describe "#execute" do
    subject(:execute) { tool.execute(selector:) }

    let(:selector) { "div.parent > span.child" }

    it "proxies to the driver" do
      allow(driver).to receive(:click).and_return({ status: :ok })
      execute
      expect(execute).to eql(status: :ok)
      expect(driver).to have_received(:click).with(selector:)
    end
  end
end
