require './spec/unit/spec_helper'

describe SimpleTodo::Interactors::AddPerson do
  
  describe "#call" do

    before do
      @repository = MiniTest::Mock.new
      @encryptor  = MiniTest::Mock.new
    end
    
    subject {  SimpleTodo::Interactors::AddPerson.new( @repository, @encryptor ) }
    
    describe "with missing and blank email address" do
            
      it "should return a response with error on email address when email address is missing" do
        response = subject.call( password: "mypassword" )
        response.errors.on(:email).must_equal( ["is required."] )
      end
      
      it "should return a response with error on email address when email address is a blank string" do
        response = subject.call( password: "mypassword", email: "   " )
        response.errors.on(:email).must_equal( ["is required."])
      end
      
    end
    
    describe "with existing email address" do
      
      before do
        @repository.expect( :exists?, true, [{email: "sam@somewhere.com"}] )
      end
      
      it "should return a response with error on email address" do
        response = subject.call( password: "mypassword", email: "sam@somewhere.com" )        
        response.errors.on(:email).must_equal( ["already exists."] )
      end
      
    end
    
    describe "with missing and blank password" do
      
      before do
        @repository.expect( :exists?, false, [Hash] )
      end
      
      it "should return a response with error on password when password is missing" do
        response = subject.call( email: "sam@somewhere.com" )
        response.errors.on(:password).must_equal( ["is required."] )
      end
      
      it "should return a response with error on password when password is a blank string" do
        response = subject.call( email: "sam@somewhere.com", password: "   " )
        response.errors.on(:password).must_equal( ["is required."] )
      end
      
    end
    
    describe "with valid email and password" do
      
      before do
        @person = SimpleTodo::Entity::Person.new( email: "sam@somewhere.com", salt: "thisismysalt", encrypted_password: "akjadfkajdfkjdfkdfj")
        @repository.expect( :exists?, false, [Hash] )
        @repository.expect( :save, @person, [SimpleTodo::Entity::Person] )
        @encryptor.expect( :salt, "thisismysalt" )
        @encryptor.expect( :encrypt, "akjadfkajdfkjdfkdfj", ["mypassword"] )
        @response = subject.call( email: "sam@somewhere.com", password: "mypassword" )
      end
      
      it "should return a response with no errors, and entity" do        
        @response.errors.must_be_empty
        @response.entity.email.must_equal @person.email
        @response.entity.salt.must_equal @person.salt
        @response.entity.encrypted_password.must_equal @person.encrypted_password
      end
      
      it "should call all the expected repository calls" do
        assert @repository.verify
      end
      
      it "should call all the expected encryptor calls" do
        assert @encryptor.verify
      end
      
    end
      
        
  end
  
end