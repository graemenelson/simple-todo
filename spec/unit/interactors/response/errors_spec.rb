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
  
  describe "#each" do
    
    subject { SimpleTodo::Interactors::Response::Errors.new }
    
    before do
      subject.add("key_1", "key_1 error message 1")
      subject.add("key_1", "key_1 error message 2")
      subject.add("key_2", "key_2 error message 1")      
    end
    
    it "should return key/value pairs for error messages" do
      actual_key_1, actual_key_2 = nil
      subject.each do |key, value|
        "key_1" == key.to_s ? actual_key_1 = value : actual_key_2 = value
      end
      actual_key_1.must_equal( ["key_1 error message 1", "key_1 error message 2"] )
      actual_key_2.must_equal( ["key_2 error message 1"] )      
    end
    
  end
  
end