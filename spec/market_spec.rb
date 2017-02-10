require 'spec_helper'

RSpec.describe NYCFarmersMarkets::Market do
  let(:hash1) do
    {
      'facilityaddinfo' =>
      'Spend $5 in EBT and get a $2 Health Buck coupon.<br><br><b>Program Website:</b> <a href="http://www.grownyc.org/youthmarket" target="_blank">http://www.grownyc.org/youthmarket</a>',
      'facilitycity' => 'Bronx',
      'facilityname' => 'Riverdale Youthmarket',
      'facilitystate' => 'NY',
      'facilitystreetname' => '256th St & Mosholu Ave',
      'facilityzipcode' => '10471',
      'latitude' => '41',
      'longitude' => '-74'
    }
  end
  let(:hash2) do
    {
      'facilityaddinfo' =>
      'Spend $5 in EBT and get a $2 Health Buck coupon.<br><br><b>Program Website:</b> <a href="http://www.grownyc.org." target="_blank">http://www.grownyc.org.</a>',
      'facilitycity' => 'Queens',
      'facilityname' => 'Astoria Greenmarket',
      'facilitystate' => 'NY',
      'facilitystreetname' => '30th Dr',
      'facilityzipcode' => '11106',
      'latitude' => '41',
      'longitude' => '-74'
    }
  end
  let(:market1) { described_class.create_from_hash(hash1) }
  let(:market2) { described_class.create_from_hash(hash2) }
  let(:market3) do
    described_class.new(borough: hash1['facilitycity'], zip_code: hash1['facilityzipcode'])
  end

  it { should respond_to(:name) }
  it { should respond_to(:additional_info) }
  it { should respond_to(:street_address) }
  it { should respond_to(:borough) }
  it { should respond_to(:state) }
  it { should respond_to(:website) }
  it { should respond_to(:zip_code) }

  describe '.create_from_hash' do
    let(:market) { described_class.create_from_hash(hash1) }

    it { expect(market.name).to eq hash1['facilityname'] }
    it { expect(market.additional_info).to eq hash1['facilityaddinfo'] }
    it { expect(market.street_address).to eq hash1['facilitystreetname'] }
    it { expect(market.borough).to eq hash1['facilitycity'] }
    it { expect(market.state).to eq hash1['facilitystate'] }
    it { expect(market.zip_code).to eq hash1['facilityzipcode'] }
  end

  describe '.find_by_borough' do
    let(:borough) { market1.borough }
    let(:markets) do
      described_class.all.select do |m|
        !m.borough.nil? && m.borough.casecmp(borough.downcase).zero?
      end
    end

    it 'can find all markets by borough' do
      expect(described_class.find_by_borough(borough)).to eq markets
    end
  end

  describe '.find_by_zip_code' do
    let(:zip_code) { market1.zip_code }
    let(:markets) do
      described_class.all.select do |m|
        !m.zip_code.nil? && m.zip_code.casecmp(zip_code.downcase).zero?
      end
    end

    it 'can find all markets by zip code' do
      expect(described_class.find_by_zip_code(zip_code)).to eq markets
    end
  end

  describe '.list_boroughs' do
    let(:boroughs) { described_class.all.map(&:borough).compact.uniq.sort }

    it 'can list all boroughs with markets' do
      expect(described_class.list_boroughs).to eq boroughs
    end
  end

  describe '.list_zip_codes' do
    let(:zip_codes) { described_class.all.map(&:zip_code).compact.uniq.sort }

    it 'can list all zip_codes with markets' do
      expect(zip_codes).to eq described_class.list_zip_codes
    end
  end

  describe '.num_markets_in_borough' do
    let(:market_count) { described_class.find_by_borough(market1.borough).count }

    it 'knows the number of markets in a single borough' do
      expect(market_count).to eq described_class.num_markets_in_borough(market1.borough)
    end
  end

  context 'private methods' do
    let(:market) { described_class.new(additional_info: hash1['facilityaddinfo']) }

    describe '#set_website_from_additional_info' do
      let(:website) { 'http://www.grownyc.org/youthmarket' }

      it 'can set the website from additonal info' do
        expect { market.send :set_website_from_additional_info }.
          to change { market.website }.to website
      end
    end

    describe '#remove_html' do
      let(:info) { 'Spend $5 in EBT and get a $2 Health Buck coupon.' }

      it 'can remove HTML from additional info' do
        expect { market.send :remove_html }.
          to change { market.additional_info }.to info
      end
    end
  end
end
