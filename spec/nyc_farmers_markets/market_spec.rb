# frozen_string_literal: true

RSpec.describe NYCFarmersMarkets::Market do
  let(:hash1) do
    {
      'additionalinfo' =>
        'Spend $5 in EBT and get a $2 Health Buck coupon.<br><br><b>'\
        'Program Website:</b> <a href="http://www.grownyc.org/youthmarket"'\
        ' target="_blank">http://www.grownyc.org/youthmarket</a>',
      'borough' => 'Bronx',
      'facilityname' => 'Riverdale Youthmarket',
      'facilitystate' => 'NY',
      'address' => '256th St & Mosholu Ave',
      'zipcode' => '10471',
      'latitude' => '41',
      'longitude' => '-74'
    }
  end
  let(:hash2) do
    {
      'additionalinfo' =>
        'Spend $5 in EBT and get a $2 Health Buck coupon.<br><br><b>'\
        'Program Website:</b> <a href="http://www.grownyc.org." '\
        'target="_blank">http://www.grownyc.org.</a>',
      'borough' => 'Queens',
      'facilityname' => 'Astoria Greenmarket',
      'facilitystate' => 'NY',
      'address' => '30th Dr',
      'zipcode' => '11106',
      'latitude' => '41',
      'longitude' => '-74'
    }
  end

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:additional_info) }
  it { is_expected.to respond_to(:street_address) }
  it { is_expected.to respond_to(:borough) }
  it { is_expected.to respond_to(:state) }
  it { is_expected.to respond_to(:website) }
  it { is_expected.to respond_to(:zip_code) }

  describe '.create_from_hash' do
    let(:additional_info) { hash1['additionalinfo'].match(/\A[^<]*/).to_s }
    let!(:market) { described_class.create_from_hash(hash1) }

    it { expect(market.name).to eq hash1['facilityname'] }
    it { expect(market.additional_info).to eq additional_info }
    it { expect(market.additional_info_raw).to eq hash1['additionalinfo'] }
    it { expect(market.street_address).to eq hash1['address'] }
    it { expect(market.borough).to eq hash1['borough'] }
    it { expect(market.state).to eq hash1['facilitystate'] }
    it { expect(market.zip_code).to eq hash1['zipcode'] }
  end

  describe '.find_by_borough' do
    let(:borough) { market.borough }
    let!(:market) { described_class.create_from_hash(hash1) }
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
    let!(:market) { described_class.create_from_hash(hash1) }
    let(:markets) do
      described_class.all.select do |m|
        !m.zip_code.nil? && m.zip_code.casecmp(zip_code.downcase).zero?
      end
    end
    let(:zip_code) { market.zip_code }

    it 'can find all markets by zip code' do
      expect(described_class.find_by_zip_code(zip_code)).to eq markets
    end
  end

  describe '.boroughs' do
    let(:boroughs) { described_class.all.map(&:borough).compact.uniq.sort }

    it 'can list all boroughs with markets' do
      expect(described_class.boroughs).to eq boroughs
    end
  end

  describe '.boroughs_lowercase' do
    let(:boroughs) do
      described_class.all.map { |m| m&.borough&.downcase }.compact.uniq.sort
    end

    before do
      described_class.create_from_hash(hash1)
      described_class.create_from_hash(hash2)
    end

    it 'can list all boroughs with markets in lowercase' do
      expect(described_class.boroughs_lowercase).to eq boroughs
    end
  end

  describe '.zip_codes' do
    let(:zip_codes) { described_class.all.map(&:zip_code).compact.uniq.sort }

    before do
      described_class.create_from_hash(hash1)
      described_class.create_from_hash(hash2)
    end

    it 'can list all zip_codes with markets' do
      expect(zip_codes).to eq described_class.zip_codes
    end
  end

  describe '.num_markets_in_borough' do
    let!(:market) { described_class.create_from_hash(hash1) }
    let(:market_count) { described_class.find_by_borough(market.borough).count }

    it 'knows the number of markets in a single borough' do
      expect(market_count).to eq described_class.num_markets_in_borough(market.borough)
    end
  end

  context 'private methods' do
    let(:market) { described_class.new(additional_info_raw: hash1['additionalinfo']) }

    describe '#set_website_from_additional_info_raw' do
      let(:website) { 'http://www.grownyc.org/youthmarket' }

      it 'can set the website from the raw additonal info' do
        expect { market.send :set_website_from_additional_info_raw }
          .to change { market.website }.to website
      end
    end

    describe '#set_additional_info' do
      let(:info) { 'Spend $5 in EBT and get a $2 Health Buck coupon.' }

      it 'can remove HTML from additional info' do
        expect { market.send :set_additional_info }
          .to change { market.additional_info }.to info
      end
    end
  end
end
