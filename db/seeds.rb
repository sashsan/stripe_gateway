# frozen_string_literal: true

[
  { name: 'Iphone X', price: 900 },
  { name: 'Samsung Z Flip 3', price: 1100 },
  { name: 'Samsung S22 Ultra', price: 1000 },
  { name: 'Samsung Z Fold 4', price: 1500 }
].each do |k|
  Product.create(k)
end
