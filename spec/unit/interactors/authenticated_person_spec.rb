require './spec/unit/spec_helper'

describe SimpleTodo::Interactors::AuthenticatePerson do
  
  describe "#call" do
    
    before do
      @repository = MiniTest::Mock.new
      @encryptor  = MiniTest::Mock.new
    end
    
    subject { SimpleTodo::Interactors::AuthenticatePerson.new( @repository, @encryptor ) }
    
    describe "with an email that does not find a person" do
      
      before do
        @repository.expect( :find_by_email, nil, ["sam@missing.com"] )
      end
      
      it "should add an error to the response base, ie invalid email and/or password" do
        response = subject.call( { email: "sam@missing.com" } )
        response.errors.on( :login ).must_equal( ["Invalid email and/or password."] )
      end
      
    end
    
    describe "with an email address that does find a person" do
      
      before do
        @person = SimpleTodo::Entity::Person.new( email: "sam@somewhere.com", salt: "mysalt", encrypted_password: "akjadflkjasdfjd" )
        @repository.expect( :find_by_email, @person, ["sam@somewhere.com"] )
      end
      
      describe "with a password that does not match encrypted password" do
        
        before do
          @encryptor.expect( :match?, false, ["akjadflkjasdfjd", "badpassword", "mysalt"])
        end
        
        it "should add an error to the response base, ie invalid email and/or password" do
          response = subject.call( {email: "sam@somewhere.com", password: "badpassword"} )
          response.errors.on( :login ).must_equal( ["Invalid email and/or password."] )
        end
        
        
      end
      
      describe "with a password that does match encrypted password" do
        
        before do
          @encryptor.expect( :match?, true, ["akjadflkjasdfjd", "goodpassword", "mysalt"] )
        end
        
        it "should assign the person to the response entity" do
          response = subject.call( {email: "sam@somewhere.com", password: "badpassword"} )
          response.errors?.must_equal( false )
          response.entity.must_equal( @person )
        end
        
      end
      
    end
    
  end
  
end