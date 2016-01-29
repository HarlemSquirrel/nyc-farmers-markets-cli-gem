class NYCFarmersMarkets::CLI

  def call
    NYCFarmersMarkets::GetMarkets.new.make_markets
    vesta = "\u26B6".encode('utf-8')
    flower = "\u2698".encode('utf-8')
    puts "\n #{vesta} Welcome to the Farmers Markets of NYC #{vesta} ".green.underline
    15.times { print "#{flower}  ".light_blue }
    puts ""

    start
  end

  def start
    hand = "\u261E".encode('utf-8')
    loop do
      puts "\nWhat would you like to do?"
      puts " #{hand} list boroughs: See a list of boroughs with Farmers Markets"
      puts " #{hand} [borough name]: See all markets in this borough"
      puts " #{hand} list zip codes: See a list of zip codes"
      puts " #{hand} [zip code]: See all markets in this zip code"
      puts " #{hand} exit: Say good-bye"
      input = gets.chomp.downcase

      case input
      when "list boroughs"
        #puts market_set.list_boroughs.join(" - ")
        list_boroughs
      when "bronx", "brooklyn", "manhattan", "queens", "staten island"
        print_by_borough(input)
      when "list zip codes"
        puts market_set.list_zipcodes.join(" - ")
      when *market_set.list_zipcodes
        print_by_zipcode(input)
      when "exit"
        puts "See you next time!"
        break
      else
        puts "Invalid selection!".red
      end
    end
  end

  def print_by_borough(borough)
    # print all the info for each market in the specified borough
    #binding.pry
    markets = market_set.find_by_borough(borough)
    puts ""
    markets.each do |market|
      puts "#{market.name}".green
      puts "#{market.street_address}, #{market.borough}, #{market.zipcode}"
      puts "#{market.additional_info}"
      puts "#{market.website}" unless market.website == nil
      puts ""
    end
  end

  def print_by_zipcode(zipcode)
    markets = market_set.find_by_zipcode(zipcode)
    puts ""
    markets.each do |market|
      puts "#{market.name}".green
      puts "#{market.street_address}, #{market.borough}, #{market.zipcode}"
      puts "#{market.additional_info}"
      puts "#{market.website}" unless market.website == nil
      puts ""
    end
  end

  def list_boroughs
    puts ""
    puts "\tBoroughs and their number of Farmers Markets".green
    #puts market_set.list_boroughs.join(" - ")
    market_set.list_boroughs.each do |b|
      print "#{b}(#{market_set.num_markets_in_borough(b)}), "
    end
    puts ""
  end

  def market_set
    NYCFarmersMarkets::Market
  end
end
