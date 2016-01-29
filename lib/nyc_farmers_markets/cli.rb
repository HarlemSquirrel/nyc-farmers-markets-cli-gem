class NYCFarmersMarkets::CLI

  def call
    NYCFarmersMarkets::GetMarkets.new.make_markets
    vesta = "\u26B6".encode('utf-8')
    flower = "\u2698".encode('utf-8')
    puts "\n\t #{vesta} Welcome to the Farmers Markets of NYC #{vesta} ".green.underline
    print "\t"; 15.times { print "#{flower}  ".light_blue }; puts ""

    start
  end

  def start
    loop do
      print "\nWhat would you like to do (type help for more info)? "

      input = gets.chomp.downcase

      case input
      when "list all"
        list_all
      when "list boroughs"
        #puts market_set.list_boroughs.join(" - ")
        list_boroughs
      when "bronx", "brooklyn", "manhattan", "queens", "staten island"
        print_by_borough(input)
      when "list zip codes"
        puts market_set.list_zipcodes.join(" - ")
      when *market_set.list_zipcodes
        print_by_zipcode(input)
      when "help"
        help
      when "exit"
        puts "See you next time!"
        break
      else
        puts "Invalid selection!".red
      end
    end
  end

  def print_by_borough(borough)
    market_set.find_by_borough(borough).each do |m|
      puts "\n#{m.name}".green
      puts "#{m.street_address}, #{m.borough}, #{m.zipcode}"
      puts "#{m.additional_info}" unless m.additional_info == nil
      puts "#{m.website}" unless m.website == nil
    end
  end

  def print_by_zipcode(zipcode)
    market_set.find_by_zipcode(zipcode).each do |m|
      puts "\n#{m.name}".green
      puts "#{m.street_address}, #{m.borough}, #{m.zipcode}"
      puts "#{m.additional_info}" unless m.additional_info == nil
      puts "#{m.website}" unless m.website == nil
    end
  end

  def list_all
    market_set.all.each do |m|
      puts "\n#{m.name}".green
      puts m.street_address == nil ? "-address not available-" : "#{m.street_address}, #{m.borough}, #{m.zipcode}"
      puts "#{m.additional_info}" unless m.additional_info == nil
      puts "#{m.website}" unless m.website == nil
    end
  end

  def list_boroughs
    puts "\n\tBoroughs and Their Number of Farmers Markets".green
    boroughs_with_num_markets = market_set.list_boroughs.collect do |b|
      "#{b}(#{market_set.num_markets_in_borough(b)})"
    end
    puts boroughs_with_num_markets.join(", ")
  end

  def help
    hand = "\u261E".encode('utf-8')
    keyboard = "\u2328".encode('utf-8')
    puts "\n #{keyboard} These are the available commands #{keyboard}".light_blue.underline
    puts "#{hand}list all\t-See a list of all Farmers Markets"
    puts "#{hand}list boroughs  -See a list of boroughs with Farmers Markets"
    puts "#{hand}[borough name] -See all markets in this borough"
    puts "#{hand}list zip codes -See a list of zip codes"
    puts "#{hand}[zip code]\t-See all markets in this zip code"
    puts "#{hand}help\t\t-See this helpful list of commands!"
    puts "#{hand}exit\t\t-Say good-bye"
  end

  def market_set
    NYCFarmersMarkets::Market
  end
end
