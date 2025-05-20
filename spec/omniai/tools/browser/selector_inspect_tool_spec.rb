# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::SelectorInspectTool do
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

    context "with valid selector" do
      subject(:execute) { tool.execute(selector: "input[type='email']") }

      it "finds elements matching the selector" do
        result = execute

        expect(result).to include("Found 1 elements matching 'input[type='email']'")
        expect(result).to include("user_email")
        expect(result).to include("type=\"email\"")
      end
    end

    context "with selector matching multiple elements" do
      subject(:execute) { tool.execute(selector: "input") }

      it "finds all matching elements" do
        result = execute

        expect(result).to include("Found 2 elements matching 'input'")
        expect(result).to include("user_email")
        expect(result).to include("user_password")
      end
    end

    context "with non-matching selector" do
      subject(:execute) { tool.execute(selector: "input[type='date']") }

      it "returns a not found message" do
        expect(execute).to eq("No elements found matching selector: input[type='date']")
      end
    end

    context "with context_size parameter" do
      subject(:execute) { tool.execute(selector: "input", context_size: 1) }

      it "includes parent context in the output" do
        result = execute

        expect(result).to include("Found 2 elements matching 'input'")
        expect(result).to include("<div")
        expect(result).to include("user_email")
        expect(result).to include("user_password")
      end
    end

    context "with context_size set to zero" do
      subject(:execute) { tool.execute(selector: "input", context_size: 0) }

      it "doesn't include parent context in the output" do
        result = execute

        expect(result).to include("Found 2 elements matching 'input'")
        expect(result).not_to include("<div id=\"email_container\"")
        expect(result).to include("<input type=\"email\"")
      end
    end
  end
end
