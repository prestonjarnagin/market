require 'minitest/autorun'
require 'minitest/pride'
require './lib/market'
require './lib/vendor'

class MarketTest < Minitest::Test

  def setup
    @market = Market.new("South Pearl Street Farmers Market")
  end

  def test_it_exists
    assert_instance_of Market, @market
  end

  def test_it_has_a_name
    assert_equal "South Pearl Street Farmers Market", @market.name
  end

  def test_it_has_no_vendors_to_start
    assert_equal [], @market.vendors
  end

  def test_it_can_add_vendors
    vendor_1 = Vendor.new("Rocky Mountain Fresh")
    vendor_1.stock("Peaches", 35)
    vendor_1.stock("Tomatoes", 7)
    vendor_2 = Vendor.new("Ba-Nom-a-Nom")
    vendor_2.stock("Banana Nice Cream", 50)
    vendor_2.stock("Peach-Raspberry Nice Cream", 25)
    @market.add_vendor(vendor_1)
    @market.add_vendor(vendor_2)
    expected = [vendor_1, vendor_2]
    assert_equal expected, @market.vendors
  end

  def test_it_can_return_vendor_names
    vendor_1 = Vendor.new("Rocky Mountain Fresh")
    vendor_1.stock("Peaches", 35)
    vendor_1.stock("Tomatoes", 7)
    vendor_2 = Vendor.new("Ba-Nom-a-Nom")
    vendor_2.stock("Banana Nice Cream", 50)
    vendor_2.stock("Peach-Raspberry Nice Cream", 25)
    @market.add_vendor(vendor_1)
    @market.add_vendor(vendor_2)
    expected = ["Rocky Mountain Fresh", "Ba-Nom-a-Nom"]
    assert_equal expected, @market.vendor_names
  end

  def test_it_can_return_vendors_that_sell_items
    vendor_1 = Vendor.new("Rocky Mountain Fresh")
    vendor_1.stock("Peaches", 35)
    vendor_1.stock("Tomatoes", 7)
    vendor_2 = Vendor.new("Ba-Nom-a-Nom")
    vendor_2.stock("Banana Nice Cream", 50)
    vendor_2.stock("Peach-Raspberry Nice Cream", 25)
    vendor_3 = Vendor.new("Palisade Peach Shack")
    vendor_3.stock("Peaches", 65)
    @market.add_vendor(vendor_1)
    @market.add_vendor(vendor_2)
    @market.add_vendor(vendor_3)
    expected = [vendor_1, vendor_3]
    assert_equal expected, @market.vendors_that_sell("Peaches")
    expected = [vendor_2]
    assert_equal expected, @market.vendors_that_sell("Banana Nice Cream")
  end

  def test_it_can_return_a_sorted_item_list
    vendor_1 = Vendor.new("Rocky Mountain Fresh")
    vendor_1.stock("Peaches", 35)
    vendor_1.stock("Tomatoes", 7)
    vendor_2 = Vendor.new("Ba-Nom-a-Nom")
    vendor_2.stock("Banana Nice Cream", 50)
    vendor_2.stock("Peach-Raspberry Nice Cream", 25)
    vendor_3 = Vendor.new("Palisade Peach Shack")
    vendor_3.stock("Peaches", 65)
    @market.add_vendor(vendor_1)
    @market.add_vendor(vendor_2)
    @market.add_vendor(vendor_3)
    expected = ["Banana Nice Cream", "Peach-Raspberry Nice Cream", "Peaches", "Tomatoes"]
    assert_equal expected, @market.sorted_item_list
  end

  def test_it_can_return_a_total_inventory_hash
    vendor_1 = Vendor.new("Rocky Mountain Fresh")
    vendor_1.stock("Peaches", 35)
    vendor_1.stock("Tomatoes", 7)
    vendor_2 = Vendor.new("Ba-Nom-a-Nom")
    vendor_2.stock("Banana Nice Cream", 50)
    vendor_2.stock("Peach-Raspberry Nice Cream", 25)
    vendor_3 = Vendor.new("Palisade Peach Shack")
    vendor_3.stock("Peaches", 65)
    @market.add_vendor(vendor_1)
    @market.add_vendor(vendor_2)
    @market.add_vendor(vendor_3)
    expected = {"Peaches"=>100,
                "Tomatoes"=>7,
                "Banana Nice Cream"=>50,
                "Peach-Raspberry Nice Cream"=>25}
    assert_equal expected, @market.total_inventory
  end

  def test_it_can_sell_stock
    vendor_1 = Vendor.new("Rocky Mountain Fresh")
    vendor_1.stock("Peaches", 35)
    @market.add_vendor(vendor_1)
    assert @market.sell("Peaches", 5)
  end

  def test_it_wont_sell_what_it_doesnt_have
    vendor_1 = Vendor.new("Rocky Mountain Fresh")
    vendor_1.stock("Peaches", 35)
    @market.add_vendor(vendor_1)
    refute @market.sell("Peaches", 36)
  end

  def test_it_will_sell_from_muliple_vendors
    vendor_1 = Vendor.new("Rocky Mountain Fresh")
    vendor_1.stock("Peaches", 35)
    vendor_2 = Vendor.new("Rocky Mountain Fresh")
    vendor_2.stock("Peaches", 35)
    @market.add_vendor(vendor_1)
    @market.add_vendor(vendor_2)
    assert @market.sell("Peaches", 60)
  end

  def test_it_will_reduce_stock
    vendor_1 = Vendor.new("Rocky Mountain Fresh")
    vendor_1.stock("Peaches", 35)
    vendor_2 = Vendor.new("Rocky Mountain Fresh")
    vendor_2.stock("Peaches", 35)
    @market.add_vendor(vendor_1)
    @market.add_vendor(vendor_2)
    @market.sell("Peaches", 60)
    assert_equal 10, @market.total_inventory["Peaches"]
  end

  def test_it_will_take_from_first_vendors_first
    vendor_1 = Vendor.new("Rocky Mountain Fresh")
    vendor_1.stock("Peaches", 35)
    vendor_2 = Vendor.new("Rocky Mountain Fresh")
    vendor_2.stock("Peaches", 35)
    @market.add_vendor(vendor_1)
    @market.add_vendor(vendor_2)
    @market.sell("Peaches", 40)
    assert_equal 0, vendor_1.check_stock("Peaches")
    assert_equal 30, vendor_2.check_stock("Peaches")
  end

  def test_sell_method_full_interaction_pattern
    vendor_1 = Vendor.new("Rocky Mountain Fresh")
    vendor_1.stock("Peaches", 35)
    vendor_1.stock("Tomatoes", 7)
    vendor_2 = Vendor.new("Ba-Nom-a-Nom")
    vendor_2.stock("Banana Nice Cream", 50)
    vendor_2.stock("Peach-Raspberry Nice Cream", 25)
    vendor_3 = Vendor.new("Palisade Peach Shack")
    vendor_3.stock("Peaches", 65)
    @market.add_vendor(vendor_1)
    @market.add_vendor(vendor_2)
    @market.add_vendor(vendor_3)
    refute @market.sell("Peaches", 200)
    refute  @market.sell("Onions", 1)
    assert @market.sell("Banana Nice Cream", 5)
    assert_equal 45, vendor_2.check_stock("Banana Nice Cream")
    assert @market.sell("Peaches", 40)
    assert_equal 0, vendor_1.check_stock("Peaches")
    assert_equal 60 ,vendor_3.check_stock("Peaches")
  end
end
