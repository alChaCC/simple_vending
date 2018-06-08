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
  # used for refresh all products and changes
  %w(changes products).each do |attr|
    define_method("reload_#{attr}".to_sym) do |options|
      send("#{attr}=", instance_variable_get("@#{attr}") << options )
    end
  end

  def sell(product_name, paid = {})
    return ['Coin not acceptable', paid] unless (paid.keys & Change::MAPPING.keys) == paid.keys
    get_money(paid)
    return "Cannot find #{product_name} in vending machine" unless current_products.map(&:name).include?(product_name)
    result = fetch_product(product_name).checking_price(Change.convert(paid))

    if result > 0
      changes = current_changes.return_charges(result, paid)
      give_money(changes)
      if changes != paid
        give_stock(product_name)
        [product_name, changes]
      else
        ['No enough changes to you, return your money', changes]
      end
    elsif result == 0
      give_stock(product_name)
      [product_name]
    elsif result < 0
      ["you need to give more money: #{result * -1}"]
    end
  end

  def get_product_history
    history_h = {}
    @products.each_with_index do |p_a, i|
      history_h["changes: #{i}"] = {}
      p_a.map do |p|
        history_h["changes: #{i}"][p.name] = {}
        history_h["changes: #{i}"][p.name]['price'] = p.price
        history_h["changes: #{i}"][p.name]['stock'] = p.stock
      end
    end
    history_h
  end

  def get_changes_history
    history_h = {}
    @changes.each_with_index do |change, i|
      history_h["changes: #{i}"] = change.changes
    end
    history_h
  end

  private

  def current_products
    @products.last.select { |p| p.stock > 0 }
  end

  def current_changes
    @changes.last
  end

  # used for track every changes come in and out
  # @param paid [Hash] money user put in
  def get_money(paid)
    @changes << Change.get_money(current_changes, paid)
  end

  # Record Money that machine give user
  # @param paid [Hash] money we give
  def give_money(paid)
    @changes << Change.give_money(current_changes, paid)
  end

  # Record stock update for product
  # @param product_name [String] product user buy
  def give_stock(product_name)
    @products << Product.give_stock(current_products, product_name)
  end

  def fetch_product(product_name)
    current_products.find { |p| p.name == product_name }
  end
end
