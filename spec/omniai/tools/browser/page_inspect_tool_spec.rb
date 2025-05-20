# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::PageInspectTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { instance_double(OmniAI::Tools::Browser::BaseDriver) }

  describe "#execute" do
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
            <form>
              <div id="email_container" class="form-field">
                <label for="user_email">Email</label>
                <input type="email" id="user_email" name="user[email]" placeholder="your@email.com">
              </div>
              <div>
                <label for="user_password">Password</label>
                <input type="password" id="user_password" name="user[password]">
              </div>
              <button type="submit">Submit</button>
            </form>
          </body>
        </html>
      HTML
    end

    before do
      allow(driver).to receive(:html).and_return(html)
    end

    context "with no parameters (default)" do
      subject(:execute) { tool.execute }

      it "returns the full HTML" do
        expect(execute).to eq(html)
      end
    end

    context "with summarize: true" do
      subject(:execute) { tool.execute(summarize: true) }

      it "returns a page summary" do
        expect(execute).to include("Test Page")
        expect(execute).to include("📝 Data Entry Fields:")
        expect(execute).to include("⚡ Primary Actions:")
        expect(execute).to include("Email (user_email)")
        expect(execute).to include("Submit (text:Submit)")
      end
    end
  end
end
