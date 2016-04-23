require "spec_helper"

describe VendingMachine do
  describe 'initialize' do
    it 'with products' do
      vm = VendingMachine.new(products: {coke: 1})
      expect(vm.products).to eq([{coke: 1}])
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
        vm = VendingMachine.new(products: {coke: 1})
        vm.reload_products({tea: 1})
        expect(vm.products).to eq([{coke: 1}, {tea: 1}])
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
end
