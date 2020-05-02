class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity, :status

  belongs_to :item
  belongs_to :order

  def subtotal
    price * quantity
  end

  def discount
    item = Item.find(item_id)
    difference = price / item.price.to_f
    100 - (difference * 100)
  end
end
