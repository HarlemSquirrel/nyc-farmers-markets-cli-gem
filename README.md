[![Code Climate](https://codeclimate.com/github/HarlemSquirrel/nyc-farmers-markets-cli-gem/badges/gpa.svg)](https://codeclimate.com/github/HarlemSquirrel/nyc-farmers-markets-cli-gem)

# NYC Farmers Markets
A Ruby Gem with CLI for the [NYC Farmers Markets API](https://dev.socrata.com/foundry/data.cityofnewyork.us/cw3p-q2v6).
Check out the [RubyGems page](https://rubygems.org/gems/nyc-farmers-markets) for this gem.

## Install Using RubyGems
```
gem install nyc-farmers-markets
```


## Build and Install from Source
Clone this repository
```
git clone https://github.com/HarlemSquirrel/nyc-farmers-markets-cli-gem.git
```
Build the gem
```
cd nyc-garmers-markets-cli-gem
gem build nyc-farmers-markets.gemspec
```
Install the gem
```
gem install ./nyc-farmers-markets-*.gem
```


## Incorporating in your own app
Require the library
```ruby
require 'nyc_farmers_markets'
```

Fetch the markets.
```ruby
markets = NYCFarmersMarkets::GetMarkets.new.make_markets
```

This will give you an array of `Market` objects. Each market has seven attributes: `additional_info`, `borough`, `name`, `state`, `street_address`, `website`, and `zipcode`. Some data may be incomplete from the API. You can access these like this:
```ruby
markets[0].name # => "Riverdale Youthmarket"
markets[0].website # => "http://www.grownyc.org/youthmarket"
```

There are a few useful class methods as well.
```ruby
NYCFarmersMarkets::Market.find_by_borough(b)
NYCFarmersMarkets::Market.find_by_zipcode(z)
NYCFarmersMarkets::Market.list_boroughs
NYCFarmersMarkets::Market.list_zipcodes
NYCFarmersMarkets::Market.num_markets_in_borough(b)
```


## Command-Line Interface
This gem will give you the `nyc-farmers-markets` executable that you can run in your terminal.
```
$ nyc-farmers-markets

	 ⚶ Welcome to the Farmers Markets of NYC ⚶
	⚘  ⚘  ⚘  ⚘  ⚘  ⚘  ⚘  ⚘  ⚘  ⚘  ⚘  ⚘  ⚘  ⚘  ⚘

What would you like to do (type help for more info)? help

 ⌨ These are the available commands ⌨
☞list all	      -See a list of all Farmers Markets
☞list boroughs  -See a list of boroughs with Farmers Markets
☞[borough name] -See all markets in this borough
☞list zip codes -See a list of zip codes
☞[zip code]	    -See all markets in this zip code
☞help		        -See this helpful list of commands!
☞exit		        -Say good-bye
```

## Tests
There is an RSpec test suite you can run.
```
rspec
```
