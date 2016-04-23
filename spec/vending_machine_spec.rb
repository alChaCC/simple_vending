require "spec_helper"

describe VendingMachine do
  describe 'initialize' do
    it 'with products' do
      product = Product.new('coke', 1)
      vm = VendingMachine.new(products: [product])
      expect(vm.products).to eq([[product]])
    end

    it 'with changes' do
      vm = VendingMachine.new(changes: {
        '1p':   1,
        '2p':   2,
        '5p':   3,
        '10p':  4,
        '20p':  5,
        '50p':  6,
        'L1':   7,
        'L2':   8})
      expect(vm.changes).to eq([{
        '1p':   1,
        '2p':   2,
        '5p':   3,
        '10p':  4,
        '20p':  5,
        '50p':  6,
        'L1':   7,
        'L2':   8}])
    end

    it 'without products or changes' do
      vm = VendingMachine.new
      expect(vm.products).to eq([])
      expect(vm.changes).to eq([])
    end
  end

  describe 'reload and record it' do
    context 'products' do
      it '- update all products' do
        product = Product.new('coke', 1)
        new_product = Product.new('tea', 1)
        vm = VendingMachine.new(products: [product])
        vm.reload_products([new_product])
        expect(vm.products).to eq([[product], [new_product]])
      end
    end

    context 'changes' do
      it '- update all changes' do
        vm = VendingMachine.new(changes: {
        '1p':   8,
        '2p':   7,
        '5p':   6,
        '10p':  5,
        '20p':  4,
        '50p':  3,
        'L1':   2,
        'L2':   1})
        vm.reload_changes({
          '1p':   1,
          '2p':   2,
          '5p':   3,
          '10p':  4,
          '20p':  5,
          '50p':  6,
          'L1':   7,
          'L2':   8})
        expect(vm.changes).to eq([
          {
            '1p':   8,
            '2p':   7,
            '5p':   6,
            '10p':  5,
            '20p':  4,
            '50p':  3,
            'L1':   2,
            'L2':   1
          },
          {
            '1p':   1,
            '2p':   2,
            '5p':   3,
            '10p':  4,
            '20p':  5,
            '50p':  6,
            'L1':   7,
            'L2':   8
          }
        ])
      end
    end
  end

  describe 'buy product' do
    before do
      @product   = Product.new('coke', 1)
      @product_2 = Product.new('tea', 0.8)
      @vm = VendingMachine.new(products: [@product, @product_2])
    end

    it 'no product found' do
      expect(@vm.sell('aloha', 100)).to eq('Cannot find aloha in vending machine')
    end

    it 'correctly' do
      expect(@vm.sell('coke', 1)).to eq(0.0)
      expect(@vm.sell('tea', 1)).to eq(0.2)
    end
  end
end
