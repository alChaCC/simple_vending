require "spec_helper"

describe Product do
  describe 'initialize' do
    it 'with correct data' do
      product = Product.new('coke', 1)
      expect(product.name).to eq('coke')
      expect(product.price).to eq(1)
    end

    it 'with error data' do
      expect{product = Product.new(nil, 1)}.to raise_error('Please make sure name is a string and price is flaot number')
      expect{product = Product.new('coke', 'hello')}.to raise_error('Please make sure name is a string and price is flaot number')
    end
  end

  describe 'check price' do
    before do
      @product = Product.new('coke', 1.2)
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
end
