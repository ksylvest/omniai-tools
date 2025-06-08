# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Browser::WatirDriver do
  subject(:driver) { described_class.new(logger:, browser:) }

  let(:browser) { instance_double(Watir::Browser) }
  let(:logger) { Logger.new(IO::NULL) }

  before do
    allow(Watir::Wait).to receive(:until).and_wrap_original do |_timeout, &block|
      block&.call
    end
  end

  describe "#click" do
    subject(:click) { driver.click(selector:) }

    let(:selector) { "button" }
    let(:element) { instance_double(Watir::Button, exists?: exists) }

    before do
      allow(browser).to receive(:element).and_return(element)
      allow(element).to receive(:click)
    end

    context "when element exists" do
      let(:exists) { true }

      it "returns the element" do
        expect(click).to eq({ status: :ok })
      end
    end

    context "when element does not exist" do
      let(:exists) { false }

      it "returns nil" do
        expect(click).to eq({ status: :error, message: "unknown selector=\"button\"" })
      end
    end
  end

  describe "#fill_in" do
    subject(:fill_in) { driver.fill_in(selector:, text:) }

    let(:selector) { "[name='email']" }
    let(:text) { "ringo@beatles.com" }
    let(:input) { instance_double(Watir::Input, exists?: exists) }
    let(:textarea) { instance_double(Watir::TextArea, exists?: exists) }

    before do
      allow(browser).to receive(:textarea).and_return(textarea)
      allow(textarea).to receive(:set)
    end

    before do
      allow(browser).to receive(:input).and_return(input)
      allow(input).to receive(:set)
    end

    context "when element exists" do
      let(:exists) { true }

      it "returns the element" do
        expect(fill_in).to eq({ status: :ok })
      end
    end

    context "when element does not exist" do
      let(:exists) { false }

      it "returns nil" do
        expect(fill_in).to eq({ status: :error, message: "unknown selector=\"[name='email']\"" })
      end
    end
  end
end
