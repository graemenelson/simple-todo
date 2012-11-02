require './spec/unit/spec_helper'

describe SimpleTodo::Interactors::Response do
  
  describe "#new" do
    
    subject { SimpleTodo::Interactors::Response.new }
    
    it "should not have any errors" do
      subject.errors?.must_equal false
    end
    
    it "should not have an entity" do
      subject.entity.must_be_nil
    end
    
  end
  
  describe "#entity=" do
    
    subject { SimpleTodo::Interactors::Response.new }
    
    it "should be able to assign entity" do
      entity = OpenStruct.new
      subject.entity=entity
      subject.entity.must_equal entity
    end
    
  end
  
end