require './spec/unit/spec_helper'

describe SimpleTodo::Repository do
  
  describe "#configuration and #for" do
    
    subject { SimpleTodo::Repository }
    
    describe "with no configuration" do
      
      before do
        subject.clear_configuration
        subject.configuration
      end
      
      it "should raise a MissingConfiguration exception when not configured" do
        proc { subject.for(:person) }.must_raise SimpleTodo::Repository::MissingConfigurationException
      end      
      
    end
    
    describe "with a configuration" do
      
      before do
        @person_repository = OpenStruct.new
        subject.configuration( {person: @person_repository} )
      end
      
      it "should raise MisingRepositoryException with in valid key" do
        proc { subject.for(:blah) }.must_raise SimpleTodo::Repository::MissingRepositoryException
      end
      
      it "should return an person repository" do
        subject.for(:person).must_equal( @person_repository )
      end
      
    end
    

    
  end
  
end