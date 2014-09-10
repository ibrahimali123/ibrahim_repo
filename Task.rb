
#Title: Ruby task and Bonus and Extra Bonus (chocolate :D) 
#Author: Ibrahim Ali Mohamed
#Team: coolSoft
#attachment "demo.txt"

require 'net/http'

def External_API_request(a , b="EGP")
    
    uri = "http://rate-exchange.appspot.com/currency?from=#{a}&to=#{b}"

    string = Net::HTTP.get(URI.parse(uri))
    
    string = string.gsub(':', ',') 
    string = string.tr('{}','')
    string  = string.split(', ') #scan for word+char
    #@@currencies[a] = string[3].to_f
    return string
end

def load_day()
    aFile = File.new("demo.txt", "r")
    if !aFile
    	puts "error in file"
    end
    day = aFile.gets
    aFile.close
    return day.to_i
end

def convertion_found(data)
	aFile = File.new("demo.txt", "r")
	if !aFile
    	puts "error in file"
    end
	my_array  = open('demo.txt').map { |line| line.split("\n")[0] }
	#puts my_array[0].to_s
	for i in 0...(my_array.length-1)
		 
         if data == my_array[i]
         	return my_array[i+1]
         end
    end
    return false   
end



class Numeric
  
  @@currencies = {'USD' => 7.15, 'EUR' => 9.26, 'JPY' => 0.068, 'EGP' => 1.0}
 
  @@currencies.each do |currency, rate|

      define_method(currency) do
      self * rate
      end

      alias_method "#{currency}s".to_sym, currency
  end



  def convert_currency(from,to)

	first_currency = from.to_s.gsub(/s$/,'')
	second_currency = to.to_s.gsub(/s$/,'')

    data = first_currency + " " + second_currency

    if(convertion_found(data) && load_day() == Time.now.day)
       return ( convertion_found(data).to_f * self )
    end

    if(!convertion_found(data) )
       data = External_API_request(first_currency,second_currency)
       aFile = File.open("demo.txt" , 'a+')
       if !aFile
    	puts "error in file"
       end
       aFile.puts first_currency + " " + second_currency
       aFile.puts  data[3]
       aFile.close
       return self * data[3].to_f
    end	
    
	if(load_day()+1 == Time.now.day)
       aFile = File.open("demo.txt" , 'w')
       if !aFile
    	puts "error in file"
       end
       aFile.puts Time.now.day
       aFile.close
	end 

  end

  def self.Add_currency(key_value)
	
	key_value.each do |key, value|
      @@currencies[key] = value
    end 
	puts @@currencies
  
  end



end


 
Numeric.Add_currency("riyal"=> 1.9)
puts 100.USD
puts 100.USDs
puts 100.convert_currency(:USD,:EUR)
puts 100.convert_currency(:USD,:EGP)
puts 10.convert_currency(:JPY,:EUR)

puts 100.convert_currency(:EGP,:USD)

