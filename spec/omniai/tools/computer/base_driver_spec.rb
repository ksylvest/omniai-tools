# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Computer::BaseDriver do
  let(:driver) { described_class.new(display_width: 1280, display_height: 1024, display_number: 0) }

  describe "#key" do
    let(:text) { "a" }

    it "raises NotImplementedError" do
      expect { driver.key(text:) }.to raise_error(NotImplementedError)
    end
  end

  describe "#hold_key" do
    let(:text) { "a" }
    let(:duration) { 2 }

    it "raises NotImplementedError" do
      expect { driver.hold_key(text:, duration:) }.to raise_error(NotImplementedError)
    end
  end

  describe "#mouse_position" do
    it "raises NotImplementedError" do
      expect { driver.mouse_position }.to raise_error(NotImplementedError)
    end
  end

  describe "#mouse_move" do
    let(:coordinate) { { x: 2, y: 3 } }

    it "raises NotImplementedError" do
      expect { driver.mouse_move(coordinate:) }.to raise_error(NotImplementedError)
    end
  end

  describe "#mouse_click" do
    let(:coordinate) { { x: 2, y: 3 } }
    let(:button) { described_class::DEFAULT_MOUSE_BUTTON }

    it "raises NotImplementedError" do
      expect { driver.mouse_click(coordinate:, button:) }.to raise_error(NotImplementedError)
    end
  end

  describe "#mouse_double_click" do
    let(:coordinate) { { x: 2, y: 3 } }
    let(:button) { described_class::DEFAULT_MOUSE_BUTTON }

    it "calls mouse_click twice" do
      allow(driver).to receive(:mouse_click).with(coordinate:, button:)
      driver.mouse_double_click(coordinate:, button:)
      expect(driver).to have_received(:mouse_click).twice
    end
  end

  describe "#mouse_triple_click" do
    let(:coordinate) { { x: 2, y: 3 } }
    let(:button) { described_class::DEFAULT_MOUSE_BUTTON }

    it "calls mouse_click three times" do
      allow(driver).to receive(:mouse_click).with(coordinate:, button:)
      driver.mouse_triple_click(coordinate:, button:)
      expect(driver).to have_received(:mouse_click).exactly(3).times
    end
  end

  describe "#mouse_down" do
    let(:coordinate) { { x: 2, y: 3 } }
    let(:button) { described_class::DEFAULT_MOUSE_BUTTON }

    it "raises NotImplementedError" do
      expect { driver.mouse_down(coordinate:, button:) }.to raise_error(NotImplementedError)
    end
  end

  describe "#mouse_up" do
    let(:coordinate) { { x: 2, y: 3 } }
    let(:button) { described_class::DEFAULT_MOUSE_BUTTON }

    it "raises NotImplementedError" do
      expect { driver.mouse_up(coordinate:, button:) }.to raise_error(NotImplementedError)
    end
  end

  describe "#mouse_drag" do
    let(:coordinate) { { x: 2, y: 3 } }
    let(:button) { described_class::DEFAULT_MOUSE_BUTTON }

    it "raises NotImplementedError" do
      allow(driver).to receive(:mouse_position).and_return({ x: 0, y: 0 })

      allow(driver).to receive(:mouse_down)
      allow(driver).to receive(:mouse_move)
      allow(driver).to receive(:mouse_up)

      driver.mouse_drag(coordinate:, button:)

      expect(driver).to have_received(:mouse_down)
      expect(driver).to have_received(:mouse_move)
      expect(driver).to have_received(:mouse_up)
    end
  end

  describe "#type" do
    let(:text) { "Hello World" }

    it "raises NotImplementedError" do
      expect { driver.type(text:) }.to raise_error(NotImplementedError)
    end
  end

  describe "#scroll" do
    let(:amount) { 512 }
    let(:direction) { "down" }

    it "raises NotImplementedError" do
      expect { driver.scroll(amount:, direction:) }.to raise_error(NotImplementedError)
    end
  end

  describe "#wait" do
    let(:duration) { 2 }

    it "sleeps for the given duration" do
      allow(Kernel).to receive(:sleep).with(duration)
      driver.wait(duration:)
      expect(Kernel).to have_received(:sleep).with(duration)
    end
  end

  describe "#screenshot" do
    it "raises NotImplementedError" do
      expect { driver.screenshot }.to raise_error(NotImplementedError)
    end
  end
end
