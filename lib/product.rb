require 'pry'
# Product Class
class Product
  attr_accessor :name, :price

  # initialize for product
  # @param name [String] name of product
  # @param price [Float] price of product
  # @return [Product]
  def initialize(name, price)
    @name  = name.to_s
    @price = price.to_f
    raise unless @name != '' && @price != 0.0
  rescue
    raise 'Please make sure name is a string and price is flaot number'
  end

  # check the price is correct or not
  def checking_price(money)
    (money.to_f - @price).round(2)
  end
end
