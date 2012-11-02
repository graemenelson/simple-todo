require './spec/integration/spec_helper'
require './lib/encryptors/bcrypt'

describe "Person" do
  
  before do
    @repository   = SimpleTodo::Repository.for( :person )
    @encryptor    = SimpleTodo::Encryptors::BCrypt.new
    @repository.clear
  end
  
  it "should have no entries in the repository" do
    @repository.count.must_equal( 0 )
  end
  
  describe "adding a person" do
    
    subject { SimpleTodo::Interactors::AddPerson.new( @repository, @encryptor ) }
    
    describe "with valid email and password" do
      
      before do
        @response = subject.call({ email: "sam@somewhere.com", password: "mypassword"})
      end
      
      it "should add a new entry" do
        @repository.count.must_equal( 1 )
      end
      
      it "should have no errors on the response" do
        @response.errors?.must_equal( false )
      end
      
      it "should have a person entity on the response" do
        person = @response.entity
        person.email.must_equal( "sam@somewhere.com" )
        person.salt.must_equal( @encryptor.salt )
        @encryptor.match?( person.encrypted_password, "mypassword", person.salt ).must_equal( true )
      end
      
      describe "try adding another person with the same email" do
        
        before do
          @person = @response.entity
          
          @existing_salt                = @person.salt
          @existing_encrypted_password  = @person.encrypted_password.to_s
          
          @new_response = subject.call({ email: "sam@somewhere.com", password: "adifferentpassword" })          
        end
        
        it "should still only have 1 entry" do
          @repository.count.must_equal( 1 )
        end
        
        it "should have an error on the response" do
          @new_response.errors?.must_equal( true )
        end
        
        it "should have an error on the email" do
          @new_response.errors.on(:email).wont_be_empty
        end
        
        it "should not change the salt of the existing person" do
          @person.salt.must_equal( @existing_salt )
        end
        
        it "should not change the encrypted password of the existing person" do
          @person.encrypted_password.to_s.must_equal( @existing_encrypted_password )
        end
        
      end
      
    end
    
    
    describe "with invalid email and password" do
      
      before do
        @response = subject.call( { email: "sam@somwehere.com" } )
      end
      
      it "should not add a new entry" do
        @repository.count.must_equal( 0 )
      end
      
      it "should have errors on @response" do
        @response.errors?.must_equal( true )
      end
      
      it "should have errors on password" do
        @response.errors.on(:password).wont_be_empty
      end
      
    end
    
  end
  
  describe "authenticating person" do
    
    subject { SimpleTodo::Interactors::AuthenticatePerson.new( @repository, @encryptor ) }
    
    before do
      @add_person = SimpleTodo::Interactors::AddPerson.new( @repository, @encryptor )
      @jim        = @add_person.call({ email: "jim@aol.com", password: "mypassword" }).entity
      @sara       = @add_person.call({ email: "sara@somewhere.com", password: "mysecret" }).entity
    end
    
    it "should have 2 people in the repository" do
      @repository.count.must_equal( 2 )
    end
    
    describe "with no email address or password" do
            
      before do
        @response = subject.call({})
      end
      
      it "should have errors on response" do
        @response.errors?.must_equal( true )
      end
      
      it "should have an error on login" do
        @response.errors.on(:login).wont_be_empty
      end
      
    end
    
    describe "with valid email address but password is wrong" do
      
      before do
        @response = subject.call({ email: @jim.email, password: "notmypassword" })
      end
      
      it "should have errors on response" do
        @response.errors?.must_equal( true )
      end
      
      it "should have an error on login" do
        @response.errors.on(:login).wont_be_empty
      end
      
    end
    
    describe "with valid email address and password" do
      
      before do
        @response = subject.call({ email: @jim.email, password: "mypassword" })
      end
      
      it "should not have errors on response" do
        @response.errors?.must_equal( false )
      end
      
      it "should assign @jim as the entity for the response" do
        @response.entity.must_equal( @jim )
      end
      
    end
    
  end
  
end