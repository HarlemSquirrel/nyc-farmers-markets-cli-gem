Gem::Specification.new do |s|
  s.name = 'nyc-farmers-markets'
  s.version = NYCFarmersMarkets::VERSION
  s.date = '2016-05-24'
  s.summary = 'Wrapper and CLI the NYC Farmers Markets API'
  s.description = 'A Ruby gem for the NYC Farmers Markets API with a CLI'
  s.authors = ['Kevin McCormack']
  s.email = 'wittyman37@yahoo.com'
  s.files = [
    'lib/nyc_farmers_markets.rb',
    'lib/nyc_farmers_markets/cli.rb',
    'lib/nyc_farmers_markets/get_markets.rb',
    'lib/nyc_farmers_markets/market.rb',
    'config/environment.rb'
  ]
  s.homepage    = 'https://github.com/HarlemSquirrel/nyc-farmers-markets-cli-gem'
  s.license     = 'MIT'
  s.executables << 'nyc-farmers-markets'

  s.add_runtime_dependency 'colorize', '~> 0.7'
  s.add_runtime_dependency 'json', '~> 1.8'
  s.add_runtime_dependency 'open-uri-cached', '>= 0.0.5'

  s.add_development_dependency 'pry', '>= 0'
  s.add_development_dependency 'rspec', '>= 3.4'
end
