# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::InspectTool do
  subject(:tool) { described_class.new(browser:) }

  let(:browser) { instance_double(Watir::Browser) }

  describe "#execute" do
    subject(:execute) { tool.execute }

    let(:html) do
      <<~HTML
        <!DOCTYPE html>
        <html>
          <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Test Page</title>
          </head>
          <body>
            <p>Hello World</p>
          </body>
        </html>
      HTML
    end

    it "visits the URL" do
      allow(browser).to receive(:html).and_return(html)
      expect(execute).to eql(html)
      expect(browser).to have_received(:html)
    end
  end
end
