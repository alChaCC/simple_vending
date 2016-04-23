# Setup

```
  git clone https://github.com/alChaCC/simple_vending
  cd simple_vending
  gem install bundle
  bundle install
```

# Usage

```
require './lib/vending_machine'
require './lib/product'
require './lib/change'

# create products
p1 = Product.new('Coke', 2.4, 10)
p2 = Product.new('Lemon Tea', 3.8, 8)
p3 = Product.new('Milk', 4.6, 6)

# create changes
changes = Change.new('1p': 1, '2p': 2, '5p': 3, '10p': 4, '20p': 5, '50p': 6, 'L1': 7, 'L2': 8)

# create Vending Machine
vending_machine = VendingMachine.new(products: [p1, p2, p3], changes: changes)

# Assume an User buy a drink
vending_machine.sell('Coke', {'L2': 1, '20p': 2})
vending_machine.sell('Lemon Tea', {'L2': 1, 'L1': 1})

# If you're owner, you can update machine

vending_machine.reload_changes(Change.new('1p': 8, '2p': 7, '5p': 6, '10p': 5, '20p': 4, '50p': 3, 'L1': 2, 'L2': 1))
vending_machine.reload_products([Product.new('Coke', 2.3, 11), Product.new('Lemon Tea', 3.8, 1), Product.new('Milk', 4.6, 5)])

# If you're owner, you can check update history
vending_machine.get_product_history
vending_machine.get_changes_history
```
