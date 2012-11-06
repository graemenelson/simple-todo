require './spec/unit/spec_helper'

describe SimpleTodo::Interactors::Response do
  
  describe "#new" do
    
    subject { SimpleTodo::Interactors::Response.new }
    
    it "should not have any errors" do
      subject.errors?.must_equal false
    end
    
  end
  
end