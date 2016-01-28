class NYCFarmersMarkets::CLI

  def call
    NYCFarmersMarkets::GetMarkets.new.make_markets
    puts " ~ ~ ~ Welcome to the Farmers Markets of NYC ~ ~ ~ "
    start
  end

  def start
    loop do
      puts "What would you like to do?"
      puts "\tlist boroughs: See a list of boroughs with Farmers Markets"
      puts "\t[borough name]: See all markets in this borough"
      puts "\tlist zip codes: See a list of zip codes"
      puts "\texit: Say good-bye"
      input = gets.chomp.downcase

      case input
      when "list boroughs"
        puts NYCFarmersMarkets::Market.list_boroughs.join(" - ")
      when "bronx", "brooklyn", "manhattan", "queens", "staten island"
        print_by_borough(input)
      when "list zip codes"
        puts NYCFarmersMarkets::Market.list_zipcodes.join(" - ")
      when "exit"
        break
      else
        puts "invalid selection"
      end
    end
  end

  def print_by_borough(borough)
    # print all the info for each market in the specified borough
    #binding.pry
    markets = NYCFarmersMarkets::Market.find_by_borough(borough)
    markets.each do |market|
      puts "#{market.name}"
      puts "#{market.street_address}, #{market.borough}, #{market.zipcode}"
      puts "#{market.additional_info}"
      puts "#{market.website}"
      puts ""
    end
  end
end
