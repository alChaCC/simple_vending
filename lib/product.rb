require 'pry'
# Product Class
class Product
  attr_accessor :name, :price, :stock

  # initialize for product
  # @param name [String] name of product
  # @param price [Float] price of product
  # @return [Product]
  def initialize(name, price, stock)
    @name  = name.to_s
    @price = price.to_f
    @stock = stock.to_i
    raise unless @name != '' && @price != 0.0 && @stock >= 0
  rescue
    raise 'Please make sure name is a string and price is flaot number and stock is more than 0'
  end

  # check the price is correct or not
  def checking_price(money)
    (money.to_f - @price).round(2)
  end

  # give stock to user and return a new Product array
  # @param change [Array] current products
  # @param money [String] product we give to user
  # @return [Array]
  def self.give_stock(current_products, product_name)
    current_products.map do |p|
      if p.name == product_name
        new(p.name, p.price, p.stock - 1)
      else
        new(p.name, p.price, p.stock)
      end
    end
  end
end
