require 'minitest/autorun'
require 'minitest/pride'
require './lib/vendor'

class VendorTest < Minitest::Test

  def setup
    @vend = Vendor.new("Rocky Mountain Fresh")
  end

  def test_it_exists
    assert_instance_of Vendor, @vend
  end

  def test_it_has_a_name
    assert_equal "Rocky Mountain Fresh", @vend.name
  end

  def test_it_has_empty_inventory_to_start
    expected = {}
    assert_equal expected, @vend.inventory
  end

  def test_it_has_no_stock_of_an_item_to_start
    assert_equal 0 , @vend.check_stock("Peaches")
  end

  def test_it_can_add_stock
    @vend.stock("Peaches", 30)
    assert_equal 30, @vend.check_stock("Peaches")
  end

  def test_its_stock_can_be_added_to
    @vend.stock("Peaches", 30)
    @vend.stock("Peaches", 25)
    assert_equal 55, @vend.check_stock("Peaches")
  end

  def test_it_can_return_its_entire_inventory
    @vend.stock("Peaches", 30)
    @vend.stock("Peaches", 25)
    @vend.stock("Tomatoes", 12)
    expected = {"Peaches" => 55, "Tomatoes" => 12}
    assert_equal expected, @vend.inventory
  end
end
