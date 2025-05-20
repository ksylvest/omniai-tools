# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::WatirDriver do
  subject(:driver) { described_class.new(logger:, browser:) }

  let(:browser) { instance_double(Watir::Browser) }
  let(:logger) { Logger.new(IO::NULL) }

  describe "#find_text_field_by" do
    let(:selector) { { id: "username" } }
    let(:element) { instance_double(Watir::TextField, exists?: exists) }

    before do
      allow(browser).to receive(:text_field).with(selector).and_return(element)
    end

    context "when element exists" do
      let(:exists) { true }

      it "returns the element" do
        expect(driver.send(:find_text_field_by, selector)).to eq(element)
      end
    end

    context "when element does not exist" do
      let(:exists) { false }

      it "returns nil" do
        expect(driver.send(:find_text_field_by, selector)).to be_nil
      end
    end
  end

  describe "#find_element_by" do
    let(:selector) { { css: ".my-class" } }
    let(:element) { instance_double(Watir::Element, exists?: exists) }

    before do
      allow(browser).to receive(:element).with(selector).and_return(element)
    end

    context "when element exists" do
      let(:exists) { true }

      it "returns the element" do
        expect(driver.send(:find_element_by, selector)).to eq(element)
      end
    end

    context "when element does not exist" do
      let(:exists) { false }

      it "returns nil" do
        expect(driver.send(:find_element_by, selector)).to be_nil
      end
    end
  end

  describe "#find_link_by" do
    let(:selector) { { text: "Home" } }
    let(:element) { instance_double(Watir::Anchor, exists?: exists) }

    before do
      allow(browser).to receive(:link).with(selector).and_return(element)
    end

    context "when element exists" do
      let(:exists) { true }

      it "returns the element" do
        expect(driver.send(:find_link_by, selector)).to eq(element)
      end
    end

    context "when element does not exist" do
      let(:exists) { false }

      it "returns nil" do
        expect(driver.send(:find_link_by, selector)).to be_nil
      end
    end
  end

  describe "#find_button_by" do
    let(:selector) { { id: "submit" } }
    let(:element) { instance_double(Watir::Button, exists?: exists) }

    before do
      allow(browser).to receive(:button).with(selector).and_return(element)
    end

    context "when element exists" do
      let(:exists) { true }

      it "returns the element" do
        expect(driver.send(:find_button_by, selector)).to eq(element)
      end
    end

    context "when element does not exist" do
      let(:exists) { false }

      it "returns nil" do
        expect(driver.send(:find_button_by, selector)).to be_nil
      end
    end
  end
end

# ...existing code...
