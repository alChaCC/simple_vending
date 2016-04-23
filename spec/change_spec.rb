require 'spec_helper'

describe Change do
  describe 'initialize' do
    it 'with correct data' do
      change = Change.new(
        '1p': 1,
        '2p': 2,
        '5p': 3,
        '10p': 4,
        '20p': 5,
        '50p': 6,
        'L1': 7,
        'L2': 8)
      expect(change.changes).to eq({
        '1p': 1,
        '2p': 2,
        '5p': 3,
        '10p': 4,
        '20p': 5,
        '50p': 6,
        'L1': 7,
        'L2': 8
      })
    end

    context 'with error data' do
      it 'no data' do
        change = Change.new
        expect(change.changes).to eq({
          '1p': 0,
          '2p': 0,
          '5p': 0,
          '10p': 0,
          '20p': 0,
          '50p': 0,
          'L1': 0,
          'L2': 0
        })
      end

      it 'error key' do
        change = Change.new(
          '1p': 1,
          '2p': 2,
          '5p': 3,
          '10p': 4,
          '100p': 5
        )
        expect(change.changes).to eq({
          '1p': 1,
          '2p': 2,
          '5p': 3,
          '10p': 4,
          '20p': 0,
          '50p': 0,
          'L1': 0,
          'L2': 0
        })
      end
    end
  end

  describe 'return_charges' do
    context 'coin enough' do
      it 'every coin is enough' do
        change = Change.new(
          '1p': 1,
          '2p': 2,
          '5p': 3,
          '10p': 4,
          '20p': 5,
          '50p': 6,
          'L1': 7,
          'L2': 8)

        expect(change.return_charges(3, {'L2': 3})).to eq({'L2': 1, 'L1': 1})
        expect(change.return_charges(2, {'L2': 3})).to eq({'L2': 1})
        expect(change.return_charges(2.5, {'L2': 3})).to eq({'L2': 1, '50p': 1})
        expect(change.return_charges(3.6, {'L2': 3})).to eq({'L2': 1, 'L1': 1, '50p': 1, '10p': 1})
        expect(change.return_charges(3.75, {'L2': 3})).to eq({'L2': 1, 'L1': 1, '50p': 1, '20p': 1, '5p': 1})
        expect(change.return_charges(3.76, {'L2': 3})).to eq({'L2': 1, 'L1': 1, '50p': 1, '20p': 1, '5p': 1, '1p': 1})
        expect(change.return_charges(3.88, {'L2': 3})).to eq({'L2': 1, 'L1': 1, '50p': 1, '20p': 1, '10p': 1, '5p': 1, '2p': 1, '1p': 1})
      end

      it 'some coins is not enough' do
        change = Change.new(
          '1p': 8,
          '2p': 0,
          '5p': 6,
          '10p': 2,
          '20p': 4,
          '50p': 3,
          'L1': 1,
          'L2': 1)

        expect(change.return_charges(4, {'L2': 3})).to eq({'L2': 1, 'L1': 1, '50p': 2})
        expect(change.return_charges(4.6, {'L2': 3})).to eq({'L2': 1, 'L1': 1, '50p': 3, '10p': 1})
        expect(change.return_charges(5.6, {'L2': 3})).to eq({'L2': 1, 'L1': 1, '50p': 3, '20p': 4, '10p': 2, '5p': 2})
        expect(change.return_charges(5.79, {'L2': 3})).to eq({'L2': 1, 'L1': 1, '50p': 3, '20p': 4, '10p': 2, '5p': 5, '1p': 4})
      end
    end

    it 'coin not enough' do
      change = Change.new(
        '1p': 1,
        '2p': 0,
        '5p': 1,
        '10p': 2,
        '20p': 4,
        '50p': 3,
        'L1': 1,
        'L2': 1)

      expect(change.return_charges(10, {'L2': 3})).to eq({'L2': 3})
      expect(change.return_charges(4.67, {'L2': 3})).to eq({'L2': 3})
      expect(change.return_charges(5.6, {'L2': 3})).to eq({'L2': 3})
      expect(change.return_charges(5.79, {'L2': 3})).to eq({'L2': 3})
    end
  end

  describe 'get/give money' do
    it 'get money' do
      change = Change.new(
        '1p': 1,
        '2p': 0,
        '5p': 1,
        '10p': 2,
        '20p': 4,
        '50p': 3,
        'L1': 1,
        'L2': 1)
      expect(Change.get_money(change, {'2p': 1}).changes).to eq({
        '1p': 1,
        '2p': 1,
        '5p': 1,
        '10p': 2,
        '20p': 4,
        '50p': 3,
        'L1': 1,
        'L2': 1
      })
    end

    it 'give money' do
      change = Change.new(
        '1p': 1,
        '2p': 0,
        '5p': 1,
        '10p': 2,
        '20p': 4,
        '50p': 3,
        'L1': 1,
        'L2': 1)
      expect(Change.give_money(change, {'5p': 1}).changes).to eq({
        '1p': 1,
        '2p': 0,
        '5p': 0,
        '10p': 2,
        '20p': 4,
        '50p': 3,
        'L1': 1,
        'L2': 1
      })
    end
  end

  describe 'convert' do
    it 'correct' do
      expect(Change.convert('2p': 1)).to eq(0.02)
      expect(Change.convert('L1': 1)).to eq(1)
    end
  end
end
