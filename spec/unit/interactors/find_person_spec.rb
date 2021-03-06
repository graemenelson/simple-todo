require './spec/unit/spec_helper'

describe SimpleTodo::Interactors::FindPerson do
  
  before do
    @repository = MiniTest::Mock.new
    @uuid       = "some-uuid-ok"
  end
  
  describe "#call" do    
    
    subject { SimpleTodo::Interactors::FindPerson.new( @repository ) }
    
    describe "with missing uuid" do
      
      it "should return an error on :uuid" do
        response = subject.call({})
        response.errors.on(:uuid).wont_be_empty
      end
      
    end
    
    describe "with invalid uuid" do
      
      before do        
        @repository.expect( :find_by_uuid, nil, [@uuid])
        @response = subject.call( uuid: @uuid )
      end
      
      it "should return an error on :uuid" do
        @response.errors.on(:uuid).wont_be_empty
      end
      
      it "should call all the expected methods on @repository" do
        @repository.verify
      end
      
      
    end
    
    describe "with valid uuid" do
      
      before do
        @person = OpenStruct.new
        @repository.expect( :find_by_uuid, @person, [@uud] )
        @response = subject.call( uuid: @uuid )
      end
      
      it "should return a response with no errors" do
        @response.errors?.must_equal( false )
      end
      
      it "should assign person to the interactor" do
        subject.person.must_equal( @person )
      end
      
      it "should call all the expected methods on @repository" do
        @repository.verify
      end
      
    end
    
  end
  
end