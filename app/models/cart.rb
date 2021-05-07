class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product)
    found_item = line_items.find_by(product: product)

    if found_item
      found_item.quantity += 1
    else
      found_item = line_items.build(product: product)
    end

    found_item
  end

  def empty?
    line_items.count == 0
  end

  def total_price
    line_items.sum(&:total_price)
  end
end
