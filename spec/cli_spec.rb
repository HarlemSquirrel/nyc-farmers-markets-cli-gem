RSpec.describe NYCFarmersMarkets::Cli do
  describe '.call' do
    let(:cli) { instance_double described_class, call: nil }

    it 'calls #call on a new instance' do
      expect(described_class).to receive(:new) { cli }
      described_class.call
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
      expect(get_markets).to receive :make_markets
      cli.call
    end
  end
end
