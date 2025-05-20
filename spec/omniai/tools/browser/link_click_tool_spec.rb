# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::LinkClickTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { instance_double(OmniAI::Tools::Browser::BaseDriver) }

  describe "#execute" do
    subject(:execute) { tool.execute(selector:) }

    let(:selector) { "Submit" }

    it "proxies to the driver" do
      allow(driver).to receive(:link_click).and_return({ status: :ok })
      execute
      expect(execute).to eql(status: :ok)
      expect(driver).to have_received(:link_click).with(selector:)
    end
  end
end
