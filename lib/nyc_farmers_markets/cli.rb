module NYCFarmersMarkets
  # The commandline interface class
  class CLI
    FLOWER = "\u2698".encode('utf-8').freeze
    FLOWER_ROW = Array.new(15, FLOWER).join('  ').freeze
    HAND = "\u261E".encode('utf-8').freeze
    KEYBOARD = "\u2328".encode('utf-8').freeze
    VESTA = "\u26B6".encode('utf-8').freeze
    WELCOME_MSG = 'Welcome to the Farmers Markets of NYC'.freeze

    def call
      NYCFarmersMarkets::GetMarkets.new.make_markets
      print_welcome
      start
    end

    def start
      loop do
        print "\nWhat would you like to do (type help for more info)? "

        input = gets.chomp.downcase

        case input
        when 'list all'
          list_all
        when 'list boroughs'
          list_boroughs
        when 'list zip codes'
          puts market_set.list_zipcodes.join(' - ')
        when 'help'
          help
        when 'exit'
          puts 'See you next time!'
          break
        when *market_set.list_boroughs.map(&:downcase)
          print_by_borough(input)
        when *market_set.list_zipcodes
          print_by_zipcode(input)
        else
          puts 'Invalid selection!'.red
        end
      end
    end

    def print_by_borough(borough)
      market_set.find_by_borough(borough).each do |market|
        print_market_info market
      end
    end

    def print_market_info(market)
      puts "\n#{market.name}".green
      if market.street_address.nil?
        puts '- address not available -'
      else
        puts "#{market.street_address}, #{market.borough}, #{market.zipcode}"
      end
      puts market.additional_info.to_s unless market.additional_info.nil?
      puts market.website.to_s unless market.website.nil?
    end

    def print_by_zipcode(zipcode)
      market_set.find_by_zipcode(zipcode).each do |market|
        print_market_info market
      end
    end

    def list_all
      market_set.all.each do |market|
        print_market_info market
      end
    end

    def list_boroughs
      puts "\n\tBoroughs and Their Number of Farmers Markets".green
      boroughs_with_num_markets = market_set.list_boroughs.collect do |b|
        "#{b}(#{market_set.num_markets_in_borough(b)})"
      end
      puts boroughs_with_num_markets.join(', ')
    end

    def help
      headline = "\n #{KEYBOARD} These are the available commands #{KEYBOARD}"
      puts headline.light_blue.underline
      puts "#{HAND}list all\t- See a list of all Farmers Markets"
      puts "#{HAND}list boroughs  - See a list of boroughs with Farmers Markets"
      puts "#{HAND}[borough name] - See all markets in this borough"
      puts "#{HAND}list zip codes - See a list of zip codes"
      puts "#{HAND}[zip code]\t- See all markets in this zip code"
      puts "#{HAND}help\t\t- See this helpful list of commands!"
      puts "#{HAND}exit\t\t- Say good-bye"
    end

    def market_set
      NYCFarmersMarkets::Market
    end

    def print_welcome
      puts "\n\t #{VESTA} #{WELCOME_MSG} #{VESTA} ".green.underline
      puts "\t#{FLOWER_ROW.light_blue}"
    end
  end
end
