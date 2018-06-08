require 'spec_helper'

describe VendingMachine do
  describe 'initialize' do
    it 'with products' do
      product = Product.new('coke', 1, 10)
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
        product = Product.new('coke', 1, 10)
        new_product = Product.new('tea', 1, 8)
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
      @product   = Product.new('coke', 1, 10)
      @product_2 = Product.new('tea', 0.8, 8)
      @product_3 = Product.new('milk', 0.8, 1)
    end

    context 'error case' do
      before do
        @vm = VendingMachine.new(products: [@product, @product_2, @product_3])
      end

      it 'no product found' do
        expect(@vm.sell('aloha', '1p': 1)).to eq('Cannot find aloha in vending machine')
      end

      it 'coin not accept' do
        expect(@vm.sell('aloha', '3p': 1)).to eq(['Coin not acceptable', {'3p': 1}])
      end

      it 'buy stock is 0' do
        expect(@vm.sell('milk', '50p': 1, '20p': 1, '10p': 1)).to eq(['milk'])
        expect(@vm.sell('milk', '50p': 1, '20p': 1, '10p': 1)).to eq('Cannot find milk in vending machine')
      end
    end


    context 'normal case' do
      before do
        @change = Change.new(
          '1p': 1,
          '2p': 2,
          '5p': 3,
          '10p': 4,
          '20p': 5,
          '50p': 6,
          'L1': 7,
          'L2': 8)
        @vm = VendingMachine.new(products: [@product, @product_2], changes: @change)
      end

      context 'user paid correctly' do
        it 'equal to price' do
          expect(@vm.sell('tea', '50p': 1, '20p': 1, '10p': 1)).to eq(['tea'])
        end

        it 'more than price' do
          expect(@vm.sell('tea', 'L1': 1)).to eq(['tea', {'20p': 1}])
        end

        it 'less than price' do
           expect(@vm.sell('tea', '1p': 1)).to eq(['you need to give more money: 0.79'])
        end
      end

      context 'user paid correctly, but run of off coin' do
        it 'more than price' do
          @change = Change.new(
          '1p': 0,
          '2p': 0,
          '5p': 0,
          '10p': 0,
          '20p': 0,
          '50p': 0,
          'L1': 1,
          'L2': 1)
          @vm.reload_changes(@change)
          expect(@vm.sell('tea', 'L1': 1)).to eq(['No enough changes to you, return your money', {'L1': 1}])
        end
      end
    end
  end

  describe 'history' do
    before do
      @product   = Product.new('coke', 1, 10)
      @product_2 = Product.new('tea', 0.8, 8)
      @change = Change.new(
        '1p': 1,
        '2p': 2,
        '5p': 3,
        '10p': 4,
        '20p': 5,
        '50p': 6,
        'L1': 7,
        'L2': 8)
      @vm = VendingMachine.new(products: [@product, @product_2], changes: @change)
    end

    context 'changes - user paid correctly' do
      it 'equal to price' do
        @vm.sell('tea', '50p': 1, '20p': 1, '10p': 1)
        expect(@vm.get_changes_history).to eq(
          { "changes: 0"=>{:"1p"=>1, :"2p"=>2, :"5p"=>3, :"10p"=>4, :"20p"=>5, :"50p"=>6, :L1=>7, :L2=>8},
            "changes: 1"=>{:"1p"=>1, :"2p"=>2, :"5p"=>3, :"10p"=>5, :"20p"=>6, :"50p"=>7, :L1=>7, :L2=>8}})
        expect(@vm.get_product_history).to eq(
          { "changes: 0"=>{"coke"=>{"price"=>1.0, "stock"=>10}, "tea"=>{"price"=>0.8, "stock"=>8}},
            "changes: 1"=>{"coke"=>{"price"=>1.0, "stock"=>10}, "tea"=>{"price"=>0.8, "stock"=>7}}})
      end

      it 'more than price' do
        @vm.sell('tea', 'L1': 1)
        expect(@vm.get_changes_history).to eq(
          { "changes: 0"=>{:"1p"=>1, :"2p"=>2, :"5p"=>3, :"10p"=>4, :"20p"=>5, :"50p"=>6, :L1=>7, :L2=>8},
            "changes: 1"=>{:"1p"=>1, :"2p"=>2, :"5p"=>3, :"10p"=>4, :"20p"=>5, :"50p"=>6, :L1=>8, :L2=>8},
            "changes: 2"=>{:"1p"=>1, :"2p"=>2, :"5p"=>3, :"10p"=>4, :"20p"=>4, :"50p"=>6, :L1=>8, :L2=>8}})
        expect(@vm.get_product_history).to eq(
          { "changes: 0"=>{"coke"=>{"price"=>1.0, "stock"=>10}, "tea"=>{"price"=>0.8, "stock"=>8}},
            "changes: 1"=>{"coke"=>{"price"=>1.0, "stock"=>10}, "tea"=>{"price"=>0.8, "stock"=>7}}})
      end

      it 'less than price' do
        @vm.sell('tea', '1p': 1)
        expect(@vm.get_changes_history).to eq(
          { "changes: 0"=>{:"1p"=>1, :"2p"=>2, :"5p"=>3, :"10p"=>4, :"20p"=>5, :"50p"=>6, :L1=>7, :L2=>8},
            "changes: 1"=>{:"1p"=>2, :"2p"=>2, :"5p"=>3, :"10p"=>4, :"20p"=>5, :"50p"=>6, :L1=>7, :L2=>8}})
        expect(@vm.get_product_history).to eq(
          { "changes: 0"=>{"coke"=>{"price"=>1.0, "stock"=>10}, "tea"=>{"price"=>0.8, "stock"=>8}}})
      end
    end

    context 'changes - user paid correctly, but run of off coin' do
      it 'more than price' do
        @change = Change.new(
        '1p': 0,
        '2p': 0,
        '5p': 0,
        '10p': 0,
        '20p': 0,
        '50p': 0,
        'L1': 1,
        'L2': 1)
        @vm.reload_changes(@change)
        @vm.sell('tea', 'L1': 1)
        expect(@vm.get_changes_history).to eq(
          { "changes: 0"=>{:"1p"=>1, :"2p"=>2, :"5p"=>3, :"10p"=>4, :"20p"=>5, :"50p"=>6, :L1=>7, :L2=>8},
            "changes: 1"=>{:"1p"=>0, :"2p"=>0, :"5p"=>0, :"10p"=>0, :"20p"=>0, :"50p"=>0, :L1=>1, :L2=>1},
            "changes: 2"=>{:"1p"=>0, :"2p"=>0, :"5p"=>0, :"10p"=>0, :"20p"=>0, :"50p"=>0, :L1=>2, :L2=>1},
            "changes: 3"=>{:"1p"=>0, :"2p"=>0, :"5p"=>0, :"10p"=>0, :"20p"=>0, :"50p"=>0, :L1=>1, :L2=>1}})
      end
    end

    it 'products' do
      @product   = Product.new('coke', 1, 10)
      @product_2 = Product.new('tea', 0.8, 8)
      @vm = VendingMachine.new(products: [@product])
      @vm.reload_products([@product_2])
      expect(@vm.get_product_history).to eq(
        { "changes: 0"=>{"coke"=>{"price"=>1.0, "stock"=>10}},
          "changes: 1"=>{"tea"=>{"price"=>0.8, "stock"=>8}}})
    end

  end
end
