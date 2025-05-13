require "rubygems"
require "nokogiri"
require "open-uri"
require 'openssl'

def hash
  page = Nokogiri::HTML(URI.open("https://coinmarketcap.com/all/views/all/"))
  
  currencies_symbol = page.xpath('//td[contains(@class, "by__symbol")]').map(&:text).map(&:strip)

  currencies_value = page.xpath('//td[contains(@class, "by__price")]').map(&:text).map(&:strip)
  
  hash_symbol_value = Hash[currencies_symbol.zip(currencies_value)]
  hash_symbol_value.each { |symbol, value| puts "#{symbol} : #{value}" }
end

hash
