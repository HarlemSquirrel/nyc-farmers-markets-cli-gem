# NYC Farmers Markets
A Ruby CLI for the [NYC Farmers Markets API](https://dev.socrata.com/foundry/data.cityofnewyork.us/cw3p-q2v6).
Check it the [RubyGems page](https://rubygems.org/gems/nyc-farmers-markets) for this gem. 

# Install Using RubyGems
```
gem install nyc-farmers-markets
```

# Build and Install from Source
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

# Command Line Interface
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
