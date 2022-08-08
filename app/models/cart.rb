class Cart
  attr_reader :items

  def initialize(items = [])
    @items = items
  end

  def add_sku(sku_id)
    pid_exist = @items.find { |item| item.sku_id == sku_id }

    if pid_exist
      pid_exist.increment!
    else
      @items << CartItem.new(sku_id)
    end
  end

  def remove_item(sku_id)
    pid_exist = @items.reject! { |item| item.sku_id == sku_id }
  end

  def empty?
    @items.empty?
  end

  def total_price
    total = @items.reduce(0) { |sum, item| sum + item.total_price }
    if total >= 1000 && holiday? 
      total * 0.9
    else
      total
    end
  end

  def holiday?
    Date.today == Date.strptime('2022-12-25', '%Y-%m-%d')
  end

  def serialize
    items = @items.map { |item| { "sku_id" => item.sku_id,
                                 "quantity" => item.quantity } }
    { "items" => items }
  end

  def self.from_hash(hash = nil)
    if hash && hash["items"]
      items = hash["items"].map { |item| 
        CartItem.new(item["sku_id"], item["quantity"])
      }
      Cart.new(items)
    else
      Cart.new
    end
  end
end
