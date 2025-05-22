# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::InspectTool do
  subject(:tool) { described_class.new(browser:) }

  let(:browser) { instance_double(Watir::Browser) }

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
      allow(browser).to receive(:html).and_return(html)
    end

    context "with no parameters" do
      subject(:execute) { tool.execute }

      it "returns a page summary" do
        expect(execute).to include("Test Page")
        expect(execute).to include("📝 Data Entry Fields:")
        expect(execute).to include("⚡ Primary Actions:")
        expect(execute).to include("Email (user_email)")
        expect(execute).to include("Submit (text:Submit)")
      end
    end

    context "with full_html: true" do
      subject(:execute) { tool.execute(full_html: true) }

      it "returns the full HTML" do
        expect(execute).to eq(html)
        expect(browser).to have_received(:html)
      end
    end

    context "with text_content parameter - matching case-insensitive" do
      subject(:execute) { tool.execute(text_content: "email") }

      it "finds elements containing the text in various forms" do
        result = execute
        expect(result).to include("Found")
        expect(result).to include("📝 Data Entry Fields:")
        expect(result).to include("Email (user_email)")
        expect(result).to include("[your@email.com]")
        expect(result).to include("🏷️ Labels & Headers:")
      end
    end

    context "with text_content parameter - no matches" do
      subject(:execute) { tool.execute(text_content: "nonexistent") }

      it "returns a not found message" do
        expect(execute).to eq("No elements found containing text: nonexistent")
      end
    end

    context "with selector parameter" do
      subject(:execute) { tool.execute(selector: "input[type='email']") }

      it "finds elements matching the selector" do
        result = execute

        expect(result).to include("Found")
        expect(result).to include("user_email")
        expect(result).to include("type=\"email\"")
      end
    end

    context "with both selector and text_content parameters" do
      subject(:execute) { tool.execute(selector: "input", text_content: "email") }

      it "finds elements matching both criteria" do
        result = execute

        expect(result).to include("Found")
        expect(result).to include("user_email")
        expect(result).not_to include("user_password")
      end
    end

    context "with context_size parameter" do
      subject(:execute) { tool.execute(text_content: "email", context_size: 1) }

      it "handles context_size parameter gracefully" do
        result = execute
        expect(result).to include("Found")
        expect(result).to include("📝 Data Entry Fields:")
        expect(result).to include("Email (user_email)")
      end
    end
  end
end
