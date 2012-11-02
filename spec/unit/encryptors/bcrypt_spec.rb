require './spec/unit/spec_helper'
require './lib/encryptors/bcrypt'

describe SimpleTodo::Encryptors::BCrypt do
  
  describe "#new" do
    
    it "should set bcrypt to ::BCrypt::Password if no value is given" do
      SimpleTodo::Encryptors::BCrypt.new.send(:bcrypt).must_equal ::BCrypt::Password
    end
    
    it "should set bcrypt to given bcrypt if one is given" do
      bcrypt = OpenStruct.new
      SimpleTodo::Encryptors::BCrypt.new(bcrypt).send(:bcrypt).must_equal bcrypt
    end
    
  end
  
  describe "#salt" do
    
    subject { SimpleTodo::Encryptors::BCrypt.new }
    
    it "should return a salt value" do
      subject.salt.wont_be_nil
    end
    
    it "should return the same salt value on repeated calls" do
      subject.salt.must_equal( subject.salt )
    end
    
  end
  
  describe "#encrypt" do
    
    before do
      @bcrypt     = MiniTest::Mock.new
      @encryptor  = SimpleTodo::Encryptors::BCrypt.new( @bcrypt )
      @string     = "my-simple-string"
    end
    
    describe "with default salt" do
      
      before do
        @bcrypt.expect( :create, "adflakdjfladfj", ["#{@encryptor.salt}--#{@string}", { cost: 10 }])
        @encrypted  = @encryptor.encrypt(@string)
      end

      it "should encrypt the string" do
        @encrypted.wont_be_nil
        @encrypted.wont_equal @string
      end
    
      it "should give same encryption for the same string" do
        @encryptor.encrypt(@string).must_equal @encrypted
      end
      
    end
    
    describe "with a given salt" do
      
      before do
        @mysalt = @encryptor.salt + "mysalt"
        @bcrypt.expect( :create, "adflakdjfladfj", ["#{@mysalt}--#{@string}", { cost: 10 }])
        @encrypted  = @encryptor.encrypt(@string, @mysalt)        
      end
      
      it "should encrypt the string" do
        @encrypted.wont_be_nil
        @encrypted.wont_equal @string
      end
    
      it "should give same encryption for the same string" do
        @encryptor.encrypt(@string).must_equal @encrypted
      end      
      
    end
  
  end
  
end