# lib = File.expand_path('../lib', __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
# require 'nyc_farmers_markets'
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "nyc_farmers_markets/version"

Gem::Specification.new do |s|
  s.name = 'nyc-farmers-markets'
  s.version = NYCFarmersMarkets::VERSION
  s.summary = 'Wrapper and CLI the NYC Farmers Markets API'
  s.description = 'A Ruby gem for the NYC Farmers Markets API with a CLI'
  s.authors = ['Kevin McCormack']
  s.email = 'HarlemSquirrel@gmail.com'
  s.files = `git ls-files -- lib/*`.split("\n")
  s.homepage    = 'https://github.com/HarlemSquirrel/nyc-farmers-markets-cli-gem'
  s.license     = 'MIT'
  s.executables << 'nyc-farmers-markets'

  s.add_runtime_dependency 'colorize', '~> 0.7'
  s.add_runtime_dependency 'json', '~> 1.8'
  s.add_runtime_dependency 'open-uri-cached', '>= 0.0.5'

  s.add_development_dependency 'rspec', '>= 3.5'
  s.add_development_dependency 'rubocop', '>= 0.47'
  s.add_development_dependency 'rubocop-rspec', '>= 1.10'
  s.add_development_dependency 'webmock', '>= 2.3.2'
end
