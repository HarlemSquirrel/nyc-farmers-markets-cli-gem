# frozen_string_literal: true

RSpec.describe NYCFarmersMarkets::Cli do
  describe '.call' do
    let(:cli) { instance_double described_class, call: nil }

    before do
      allow(described_class).to receive(:new) { cli }
    end

    it 'calls #call on a new instance' do
      described_class.call
      expect(cli).to have_received(:call)
    end
  end

  describe '#call' do
    let(:cli) { described_class.new }
    let(:flower_row) { described_class::FLOWER_ROW }
    let(:get_markets) { instance_double NYCFarmersMarkets::GetMarkets, make_markets: nil }
    let(:welcome_msg) { described_class::WELCOME_MSG }

    before do
      allow(cli).to receive(:start) { nil }
      allow(NYCFarmersMarkets::GetMarkets).to receive(:new) { get_markets }
    end

    it 'displays the welcome message' do
      expect { cli.call }.to output(/#{welcome_msg}/).to_stdout
    end

    it 'displays the flower row' do
      expect { cli.call }.to output(/#{flower_row}/).to_stdout
    end

    it 'makes a new set of markets' do
      cli.call
      expect(get_markets).to have_received :make_markets
    end
  end
end
