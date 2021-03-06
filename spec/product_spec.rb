require 'spec_helper'

describe Product do
  describe 'initialize' do
    it 'with correct data' do
      product = Product.new('coke', 1, 10)
      expect(product.name).to eq('coke')
      expect(product.price).to eq(1)
      expect(product.stock).to eq(10)
    end

    it 'with error data' do
      expect{product = Product.new(nil, 1, 10)}.to raise_error('Please make sure name is a string and price is flaot number and stock is more than 0')
      expect{product = Product.new('coke', 'hello', 10)}.to raise_error('Please make sure name is a string and price is flaot number and stock is more than 0')
    end
  end

  describe 'check price' do
    before do
      @product = Product.new('coke', 1.2, 10)
    end

    it '> 0' do
      expect(@product.checking_price(2)).to eq(0.8)
    end

    it '< 0' do
      expect(@product.checking_price(0.8)).to eq(-0.4)
    end

    it '= 0' do
      expect(@product.checking_price(1.2)).to eq(0.0)
    end

    it 'money is not a number' do
      expect(@product.checking_price('hello')).to eq(-1.2)
    end
  end

  it 'give stock' do
    current_p  = Product.new('coke', 1, 10)
    updated_p  = Product.give_stock([current_p], 'coke')
    expect(updated_p.last.stock).to eq(9)
  end
end
