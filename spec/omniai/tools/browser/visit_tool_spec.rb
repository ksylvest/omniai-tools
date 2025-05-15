# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::VisitTool do
  subject(:tool) { described_class.new(browser:) }

  let(:browser) { instance_double(Watir::Browser) }

  describe "#execute" do
    subject(:execute) { tool.execute(url:) }

    let(:url) { "https://news.ycombinator.com" }

    it "visits the URL" do
      allow(browser).to receive(:goto).with(url)
      expect(execute).to be_nil
      expect(browser).to have_received(:goto).with(url)
    end
  end
end
