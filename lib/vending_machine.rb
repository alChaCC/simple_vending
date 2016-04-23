require 'pry'
# Vending Machine Class
class VendingMachine
  attr_accessor :products, :changes

  # initialize for vendingmachine
  # @param options [Hash] options for the method (options = {})
  # @param options [Array] :products array of products
  # @param options [Array] :changes array of changes
  # @return [void]
  def initialize(options = {})
    @products = []
    @changes  = []
    @products << options[:products] if options[:products]
    @changes  << options[:changes] if options[:changes]
  end

  # Reload attribute and tracking changes
  %w(changes products).each do |attr|
    define_method("reload_#{attr}".to_sym) do |options|
      send("#{attr}=", instance_variable_get("@#{attr}") << options )
    end
  end

  def sell(product_name, paid)
    return "Cannot find #{product_name} in vending machine" unless current_products.map(&:name).include?(product_name)
    result = fetch_product(product_name).checking_price(paid)
  end

  private

  def current_products
    @products.last
  end

  def current_changes
    @changes.last
  end

  def fetch_product(product_name)
    current_products.find { |p| p.name == product_name }
  end
end
