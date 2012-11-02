require './spec/unit/spec_helper'

describe SimpleTodo::Entity::Person do
  
  describe "#new" do
    
    it "should be able to set email" do
      person = SimpleTodo::Entity::Person.new( email: "sam@somewhere.com" )
      person.email.must_equal "sam@somewhere.com"
    end
    
    it "should be able to set salt" do
      person = SimpleTodo::Entity::Person.new( salt: "mysalt" )
      person.salt.must_equal "mysalt"
    end
    
    it "should be able to set encrypted_passwrod" do
      person = SimpleTodo::Entity::Person.new( encrypted_password: "ajdkadjfkajdf" )
      person.encrypted_password.must_equal "ajdkadjfkajdf"
    end
    
  end
  
end