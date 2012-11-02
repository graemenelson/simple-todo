require './spec/unit/spec_helper'

describe SimpleTodo::Interactors::Response::Errors do
  
  describe "#new"  do
    
    subject { SimpleTodo::Interactors::Response::Errors.new }
    
    it "should not have any errors" do
      subject.any?.must_equal false
    end
    
    it "should no errors" do
      subject.empty?.must_equal true
    end
    
  end
  
  describe "#add and #on" do
    
    subject { SimpleTodo::Interactors::Response::Errors.new }
    
    describe "add a new key with message" do
      
      it "should add a new message for the given key" do
        subject.add("test", "my message")
        subject.on("test").must_equal ["my message"]
      end
      
      it "should append a new message for a given key that already has one message" do
        subject.add("test", "my first message")
        subject.add("test", "my second message")
        subject.on("test").must_equal ["my first message", "my second message"]
      end
      
      it "should not return a message for a different key" do
        subject.add("test", "my message")
        subject.on("blah").must_equal []
      end
      
    end
    
  end
  
end