class Cart
  attr_reader :contents, :discounts

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    total = item.price * @contents[item.id.to_s]
    total - (discount(item.id) * total)
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity - (discount(item_id) * Item.find(item_id).price * quantity)
    end
  end

  def add_quantity(item)
    @contents[item] += 1
  end

  def subtract_quantity(item)
    @contents[item] -= 1
  end

  def quantity_zero?(item)
    @contents[item].zero?
  end

  def limit_reached?(item)
    @contents[item] == Item.find(item).inventory
  end

  def discount(item_id)
    item = Item.find(item_id)
    merchant = Merchant.find(item.merchant_id)
    discounts = merchant.discounts.where('amount <= ?', @contents[item.id.to_s]).order(percent: :desc)
    if discounts.first == nil
      0
    else
      discounts.first.percent / 100.00
    end
  end

  def check_discount(item_id)
    item = Item.find(item_id)
    merchant = Merchant.find(item.merchant_id)
    discounts = merchant.discounts.where('amount <= ?', @contents[item.id.to_s]).order(percent: :desc)
    if discounts.first != nil
      discounts.first.percent
    else
      0
    end
  end
end
