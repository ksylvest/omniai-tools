# frozen_string_literal: true

RSpec.describe OmniAI::Tools::ComputerTool do
  subject(:tool) { described_class.new(driver:) }

  let(:driver) { instance_double(OmniAI::Tools::Computer::BaseDriver) }

  describe "#execute" do
    context "when the action is 'key'" do
      subject(:execute) { tool.execute(action:, text:) }

      let(:action) { OmniAI::Tools::ComputerTool::Action::KEY }
      let(:text) { "CMD+Q" }

      it "calls the driver" do
        allow(driver).to receive(:key).with(text:)
        execute
        expect(driver).to have_received(:key).with(text:)
      end
    end

    context "when the action is 'hold_key'" do
      subject(:execute) { tool.execute(action:, text:, duration:) }

      let(:action) { OmniAI::Tools::ComputerTool::Action::HOLD_KEY }
      let(:text) { "Shift" }
      let(:duration) { 2 }

      it "calls the driver" do
        allow(driver).to receive(:hold_key).with(text:, duration:)
        execute
        expect(driver).to have_received(:hold_key).with(text:, duration:)
      end
    end

    context "when the action is 'mouse_position'" do
      subject(:execute) { tool.execute(action:) }

      let(:action) { OmniAI::Tools::ComputerTool::Action::MOUSE_POSITION }

      it "calls the driver" do
        allow(driver).to receive(:mouse_position)
        execute
        expect(driver).to have_received(:mouse_position)
      end
    end

    context "when the action is 'mouse_move'" do
      subject(:execute) { tool.execute(action:, coordinate:) }

      let(:action) { OmniAI::Tools::ComputerTool::Action::MOUSE_MOVE }
      let(:coordinate) { { x: 2, y: 3 } }

      it "calls the driver" do
        allow(driver).to receive(:mouse_move).with(coordinate:)
        execute
        expect(driver).to have_received(:mouse_move).with(coordinate:)
      end
    end

    context "when the action is 'mouse_click'" do
      subject(:execute) { tool.execute(action:, coordinate:, mouse_button:) }

      let(:action) { OmniAI::Tools::ComputerTool::Action::MOUSE_CLICK }
      let(:coordinate) { { x: 2, y: 3 } }
      let(:mouse_button) { "left" }

      it "calls the driver" do
        allow(driver).to receive(:mouse_click).with(coordinate:, button: mouse_button)
        execute
        expect(driver).to have_received(:mouse_click).with(coordinate:, button: mouse_button)
      end
    end

    context "when the action is 'mouse_down'" do
      subject(:execute) { tool.execute(action:, coordinate:, mouse_button:) }

      let(:action) { OmniAI::Tools::ComputerTool::Action::MOUSE_DOWN }
      let(:coordinate) { { x: 2, y: 3 } }
      let(:mouse_button) { "right" }

      it "calls the driver" do
        allow(driver).to receive(:mouse_down).with(coordinate:, button: mouse_button)
        execute
        expect(driver).to have_received(:mouse_down).with(coordinate:, button: mouse_button)
      end
    end

    context "when the action is 'mouse_drag'" do
      subject(:execute) { tool.execute(action:, coordinate:, mouse_button:) }

      let(:action) { OmniAI::Tools::ComputerTool::Action::MOUSE_DRAG }
      let(:coordinate) { { x: 2, y: 3 } }
      let(:mouse_button) { "middle" }

      it "calls the driver" do
        allow(driver).to receive(:mouse_drag).with(coordinate:, button: mouse_button)
        execute
        expect(driver).to have_received(:mouse_drag).with(coordinate:, button: mouse_button)
      end
    end

    context "when the action is 'mouse_up'" do
      subject(:execute) { tool.execute(action:, coordinate:, mouse_button:) }

      let(:action) { OmniAI::Tools::ComputerTool::Action::MOUSE_UP }
      let(:coordinate) { { x: 2, y: 3 } }
      let(:mouse_button) { "left" }

      it "calls the driver" do
        allow(driver).to receive(:mouse_up).with(coordinate:, button: mouse_button)
        execute
        expect(driver).to have_received(:mouse_up).with(coordinate:, button: mouse_button)
      end
    end

    context "when the action is 'mouse_double_click'" do
      subject(:execute) { tool.execute(action:, coordinate:, mouse_button:) }

      let(:action) { OmniAI::Tools::ComputerTool::Action::MOUSE_DOUBLE_CLICK }
      let(:coordinate) { { x: 2, y: 3 } }
      let(:mouse_button) { "left" }

      it "calls the driver" do
        allow(driver).to receive(:mouse_double_click).with(coordinate:, button: mouse_button)
        execute
        expect(driver).to have_received(:mouse_double_click).with(coordinate:, button: mouse_button)
      end
    end

    context "when the action is 'mouse_triple_click'" do
      subject(:execute) { tool.execute(action:, coordinate:, mouse_button:) }

      let(:action) { OmniAI::Tools::ComputerTool::Action::MOUSE_TRIPLE_CLICK }
      let(:coordinate) { { x: 1, y: 2 } }
      let(:mouse_button) { "right" }

      it "calls the driver" do
        allow(driver).to receive(:mouse_triple_click).with(coordinate:, button: mouse_button)
        execute
        expect(driver).to have_received(:mouse_triple_click).with(coordinate:, button: mouse_button)
      end
    end

    context "when the action is 'type'" do
      subject(:execute) { tool.execute(action:, text:) }

      let(:action) { OmniAI::Tools::ComputerTool::Action::TYPE }
      let(:text) { "Hello, world!" }

      it "calls the driver" do
        allow(driver).to receive(:type).with(text:)
        execute
        expect(driver).to have_received(:type).with(text:)
      end
    end

    context "when the action is 'scroll'" do
      subject(:execute) { tool.execute(action:, scroll_amount:, scroll_direction:) }

      let(:action) { OmniAI::Tools::ComputerTool::Action::SCROLL }
      let(:scroll_amount) { 3 }
      let(:scroll_direction) { "down" }

      it "calls the driver" do
        allow(driver).to receive(:scroll).with(amount: scroll_amount, direction: scroll_direction)
        execute
        expect(driver).to have_received(:scroll).with(amount: scroll_amount, direction: scroll_direction)
      end
    end

    context "when the action is 'wait'" do
      subject(:execute) { tool.execute(action:, duration:) }

      let(:action) { OmniAI::Tools::ComputerTool::Action::WAIT }
      let(:duration) { 5 }

      it "calls the driver" do
        allow(driver).to receive(:wait).with(duration:)
        execute
        expect(driver).to have_received(:wait).with(duration:)
      end
    end
  end
end
