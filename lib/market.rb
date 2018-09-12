class Market
  attr_reader :name,
              :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor.inventory.include?(item)
    end
  end

  def sorted_item_list
    items = @vendors.map do |vendor|
      vendor.inventory.keys
    end.flatten
    items.uniq.sort
  end

  def total_inventory
    hash = Hash.new(0)
    @vendors.each do |vendor|
      #TODO Group By?
      vendor.inventory.each do |item, quantity|
        hash[item] += quantity
      end
    end
    return hash
  end

  def sell(item, quantity)
    return false if total_inventory[item] <= quantity

    @vendors.each do |vendor|
      if quantity >= vendor.check_stock(item)
        quantity -= vendor.inventory[item]
        vendor.inventory[item] = 0
      else
        vendor.inventory[item] -= quantity
        quantity = 0
      end
    end
    return true
  end

end
