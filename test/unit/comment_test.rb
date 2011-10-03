require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def test_should_be_valid
    comment = Comment.new()
    comment.message = "test"
    comment.invoice_id = 1
    assert comment.valid?
  end

    def test_should_be_invalid
    comment = Comment.new()    
    assert !comment.valid?    

  end

end
