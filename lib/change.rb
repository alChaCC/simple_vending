require 'pry'
# Change Class
class Change
  attr_accessor :changes

  MAPPING = {
    '1p':  0.01,
    '2p':  0.02,
    '5p':  0.05,
    '10p': 0.1,
    '20p': 0.2,
    '50p': 0.5,
    'L1':  1.0,
    'L2':  2.0
  }
  # initialize for product
  # @param changes [Hash] changes
  # @return [Change]
  def initialize(changes = {})
    @changes = {
      '1p': 0,
      '2p': 0,
      '5p': 0,
      '10p': 0,
      '20p': 0,
      '50p': 0,
      'L1': 0,
      'L2': 0
    }
    # only merge 1p, 2p, ...etc
    @changes.merge!(changes.select { |k| @changes.keys.include? k })
  end

  # return charge for user
  # @param money [Float] the money we need to return
  # @param paid  [Hash]  the money user paid
  # @return [Hash]
  def return_charges(money, paid)
    return_coins = {}
    left_money = money
    Change::MAPPING.values.reverse.each do |denomination|
      number_of_coins = @changes[Change::MAPPING.key(denomination)]
      # no coin just move to next denomination
      next if number_of_coins == 0
      # although has coin, but bigger than left_money move to next denomination
      coin_needed = Integer(left_money / denomination)
      next if coin_needed == 0
      # the denomination coin is not enough
      if coin_needed > number_of_coins
        # get all coin
        return_coins[Change::MAPPING.key(denomination)] = number_of_coins
        # subtract left_money
        left_money = (left_money - number_of_coins * denomination).round(2)
      else
        # get coin
        return_coins[Change::MAPPING.key(denomination)] = coin_needed
        # subtract left_money
        left_money = (left_money - coin_needed * denomination).round(2)
      end
    end
    left_money == 0 ? return_coins : paid
  end

  # get/give money from user / to user and return a new Change object
  # @param change [Change] current changes
  # @param money [Hash] money we get or give
  # @return [Change]
  %w(get give).each do |action|
    define_singleton_method "#{action}_money".to_sym do |change, money|
      return_h = {}
      change ||= new
      change.changes.each do |k, v|
        if action == 'get'
          return_h[k] = money[k] ? (v + money[k]) : v
        else
          return_h[k] = money[k] ? (v - money[k]) : v
        end
      end
      new(return_h)
    end
  end

  # Convert coin to value
  # @param money [Hash] money
  # @return [Float]
  def self.convert(money = {})
    total = 0.0
    money.each do |k, v|
      next unless MAPPING[k]
      total += MAPPING[k] * v
    end
    total
  end
end
