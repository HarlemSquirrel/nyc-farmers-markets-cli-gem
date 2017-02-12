# frozen_string_literal: true

module NYCFarmersMarkets
  EXIT_CMD = 'exit'
  FLOWER = "\u2698".encode('utf-8')
  FLOWER_ROW = Array.new(15, FLOWER).join('  ')
  HAND = "\u261E".encode('utf-8')
  KEYBOARD = "\u2328".encode('utf-8')
  CMD_LIST = [
    'exit',
    'help',
    'list all',
    'list boroughs',
    'list zip codes',
    'version'
  ].flatten
  VESTA = "\u26B6".encode('utf-8')
  WELCOME_MSG = 'Welcome to the Farmers Markets of NYC'

  # The commandline interface class
  class Cli
    def self.call
      new.call
    end

    def call
      NYCFarmersMarkets::GetMarkets.new.make_markets
      print_welcome
      start
    end

    private

    def start
      loop do
        input = prompt_user
        interpret(input)
        break if input == EXIT_CMD
      end
    end

    def prompt_user
      print "\nWhat would you like to do (type help for more info)? "
      gets.chomp.downcase
    end

    def interpret(input)
      case input
      when *CMD_LIST
        send input.gsub(/\s/, '_').to_sym
      when *market_set.boroughs_lowercase
        print_by_borough(input)
      when *market_set.zip_codes
        print_by_zip_code(input)
      else
        puts 'Invalid selection!'.red
      end
    end

    def exit
      puts 'See you next time!'
    end

    def print_by_borough(borough)
      market_set.find_by_borough(borough).each do |market|
        print_market_info market
      end
    end

    def print_by_zip_code(zip_code)
      market_set.find_by_zip_code(zip_code).each do |market|
        print_market_info market
      end
    end

    def print_market_info(market)
      info = "\n#{market.name}\n".green
      info << "#{market.full_address}\n"
      info << "#{market.additional_info}\n" unless market.additional_info.nil?
      info << "#{market.website}\n" unless market.website.nil?
      puts info
    end

    def list_all
      market_set.all.each do |market|
        print_market_info market
      end
    end

    def list_boroughs
      puts "\n\tBoroughs and Their Number of Farmers Markets".green
      boroughs_with_num_markets = market_set.boroughs.collect do |b|
        "#{b}(#{market_set.num_markets_in_borough(b)})"
      end
      puts boroughs_with_num_markets.join(', ')
    end

    def list_zip_codes
      puts market_set.zip_codes.join(' - ')
    end

    def help
      headline = "\n #{KEYBOARD} These are the available commands #{KEYBOARD}"
      puts headline.light_blue.underline
      puts "#{HAND} list all\t - See a list of all Farmers Markets"
      puts "#{HAND} list boroughs  - See a list of boroughs with Farmers Markets"
      puts "#{HAND} [borough name] - See all markets in this borough"
      puts "#{HAND} list zip codes - See a list of zip codes"
      puts "#{HAND} [zip code]\t - See all markets in this zip code"
      puts "#{HAND} help\t\t - See this helpful list of commands!"
      puts "#{HAND} version\t - See the currently running version!"
      puts "#{HAND} exit\t\t - Say good-bye"
    end

    def market_set
      @market_set ||= NYCFarmersMarkets::Market
    end

    def print_welcome
      puts "\n\t #{VESTA} #{WELCOME_MSG} #{VESTA} ".green.underline
      puts "\t#{FLOWER_ROW.light_blue}"
    end

    def version
      puts NYCFarmersMarkets::VERSION
    end
  end
end
