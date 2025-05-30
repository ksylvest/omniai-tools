# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Computer::MacDriver do
  let(:driver) { described_class.new(keyboard:, mouse:, display:) }
  let(:keyboard) { instance_double(MacOS::Keyboard) }
  let(:mouse) { instance_double(MacOS::Mouse) }
  let(:display) { instance_double(MacOS::Display, wide: 1280, high: 1024, id: 0) }

  describe "#key" do
    let(:text) { "CMD+SHIFT+S" }

    it "raises NotImplementedError" do
      allow(keyboard).to receive(:keys).with(text)
      driver.key(text:)
      expect(keyboard).to have_received(:keys).with(text)
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
    it "uses the mouse" do
      allow(mouse).to receive(:position).and_return(instance_double(MacOS::Mouse::Position, x: 2, y: 2))
      expect(driver.mouse_position).to eq({ x: 2, y: 2 })
    end
  end

  describe "#mouse_move" do
    let(:coordinate) { { x: 2, y: 3 } }

    it "uses the mouse" do
      allow(mouse).to receive(:move).with(x: 2, y: 3)
      driver.mouse_move(coordinate:)
      expect(mouse).to have_received(:move).with(x: 2, y: 3)
    end
  end

  describe "#mouse_click" do
    let(:coordinate) { { x: 2, y: 3 } }

    context "when using the left button" do
      let(:button) { "left" }

      it "uses the mouse" do
        allow(mouse).to receive(:left_click).with(x: 2, y: 3)
        driver.mouse_click(coordinate:, button:)
        expect(mouse).to have_received(:left_click).with(x: 2, y: 3)
      end
    end

    context "when using the middle button" do
      let(:button) { "middle" }

      it "uses the mouse" do
        allow(mouse).to receive(:middle_click).with(x: 2, y: 3)
        driver.mouse_click(coordinate:, button:)
        expect(mouse).to have_received(:middle_click).with(x: 2, y: 3)
      end
    end

    context "when using the right button" do
      let(:button) { "right" }

      it "uses the mouse" do
        allow(mouse).to receive(:right_click).with(x: 2, y: 3)
        driver.mouse_click(coordinate:, button:)
        expect(mouse).to have_received(:right_click).with(x: 2, y: 3)
      end
    end
  end

  describe "#mouse_down" do
    let(:coordinate) { { x: 2, y: 3 } }

    context "when using the left button" do
      let(:button) { "left" }

      it "uses the mouse" do
        allow(mouse).to receive(:left_down).with(x: 2, y: 3)
        driver.mouse_down(coordinate:, button:)
        expect(mouse).to have_received(:left_down).with(x: 2, y: 3)
      end
    end

    context "when using the middle button" do
      let(:button) { "middle" }

      it "uses the mouse" do
        allow(mouse).to receive(:middle_down).with(x: 2, y: 3)
        driver.mouse_down(coordinate:, button:)
        expect(mouse).to have_received(:middle_down).with(x: 2, y: 3)
      end
    end

    context "when using the right button" do
      let(:button) { "right" }

      it "uses the mouse" do
        allow(mouse).to receive(:right_down).with(x: 2, y: 3)
        driver.mouse_down(coordinate:, button:)
        expect(mouse).to have_received(:right_down).with(x: 2, y: 3)
      end
    end
  end

  describe "#mouse_up" do
    let(:coordinate) { { x: 2, y: 3 } }

    context "when using the left button" do
      let(:button) { "left" }

      it "uses the mouse" do
        allow(mouse).to receive(:left_up).with(x: 2, y: 3)
        driver.mouse_up(coordinate:, button:)
        expect(mouse).to have_received(:left_up).with(x: 2, y: 3)
      end
    end

    context "when using the middle button" do
      let(:button) { "middle" }

      it "uses the mouse" do
        allow(mouse).to receive(:middle_up).with(x: 2, y: 3)
        driver.mouse_up(coordinate:, button:)
        expect(mouse).to have_received(:middle_up).with(x: 2, y: 3)
      end
    end

    context "when using the right button" do
      let(:button) { "right" }

      it "uses the mouse" do
        allow(mouse).to receive(:right_up).with(x: 2, y: 3)
        driver.mouse_up(coordinate:, button:)
        expect(mouse).to have_received(:right_up).with(x: 2, y: 3)
      end
    end
  end

  describe "#type" do
    let(:text) { "Hello World" }

    it "raises NotImplementedError" do
      allow(keyboard).to receive(:type).with(text)
      driver.type(text:)
      expect(keyboard).to have_received(:type).with(text)
    end
  end

  describe "#scroll" do
    let(:amount) { 512 }
    let(:direction) { "down" }

    it "raises NotImplementedError" do
      expect { driver.scroll(amount:, direction:) }.to raise_error(NotImplementedError)
    end
  end

  describe "#screenshot" do
    let(:file) { instance_double(File) }

    it "uses the display" do
      allow(display).to receive(:screenshot).and_yield(file)
      expect { |block| driver.screenshot(&block) }.to yield_with_args(file)
      expect(display).to have_received(:screenshot)
    end
  end
end
