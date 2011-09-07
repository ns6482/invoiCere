require 'test_helper'

class InvoiceItemTest < ActiveSupport::TestCase
  def test_should_be_valid
    invoice_item = Factory.create(:invoice_item)
    assert invoice_item.valid?
  end

  def test_failing_invoice
    invoice_item = InvoiceItem.new
    assert !invoice_item.save
    assert_equal 6, invoice_item.errors.size
  
    assert_equal invoice_item.errors[:item_type].count, 1
    assert_equal invoice_item.errors[:item_description].count, 1
    assert_equal invoice_item.errors[:qty].count, 2
    assert_equal invoice_item.errors[:cost].count, 2
  end

  def test_failing_bad_qty_value
    invoice_item = Factory.build(:invoice_item, :qty => "bad")
    assert !invoice_item.save
  end

  def test_failing_bad_cost_value
    invoice_item = Factory.build(:invoice_item, :cost => "bad")
    assert !invoice_item.save
  end

  def test_total_cost
    invoice_item = Factory.build(:invoice_item, :taxable => false)
    invoice_item.cost = 10
    invoice_item.qty = 10
  

    assert_equal 100, invoice_item.line_cost
    assert_equal 100, invoice_item.line_cost_inc_tax
  end

  def test_total_cost_inc_tax

    invoice = Factory.create(:invoice, :tax_rate => 10)
    invoice_item = Factory.build(:invoice_item, :invoice_id => invoice.id, :taxable => true)
    invoice_item.cost = 10
    invoice_item.qty = 10
   

    assert_equal 100, invoice_item.line_cost
    assert_equal 110, invoice_item.line_cost_inc_tax.to_i

  end

end


