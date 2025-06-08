# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::BaseDriver do
  subject(:driver) { described_class.new }

  describe "#close" do
    it "raises NotImplementedError" do
      expect { driver.close }.to raise_error(NotImplementedError)
    end
  end

  describe "#url" do
    it "raises NotImplementedError" do
      expect { driver.url }.to raise_error(NotImplementedError)
    end
  end

  describe "#title" do
    it "raises NotImplementedError" do
      expect { driver.title }.to raise_error(NotImplementedError)
    end
  end

  describe "#html" do
    it "raises NotImplementedError" do
      expect { driver.html }.to raise_error(NotImplementedError)
    end
  end

  describe "#screenshot" do
    it "raises NotImplementedError" do
      expect { driver.screenshot }.to raise_error(NotImplementedError)
    end
  end

  describe "#goto" do
    it "raises NotImplementedError" do
      expect { driver.goto(url: "http://example.com") }.to raise_error(NotImplementedError)
    end
  end

  describe "#fill_in" do
    it "raises NotImplementedError" do
      expect { driver.fill_in(selector: "#input", text: "foo") }.to raise_error(NotImplementedError)
    end
  end

  describe "#click" do
    it "raises NotImplementedError" do
      expect { driver.click(selector: "#btn") }.to raise_error(NotImplementedError)
    end
  end
end
