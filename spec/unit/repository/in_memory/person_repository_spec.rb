require './spec/unit/spec_helper'
require './lib/repository/in_memory'

describe SimpleTodo::Repository::InMemory::PersonRepository do
  
  Person = SimpleTodo::Entity::Person
  
  describe "#save" do
    
    subject { SimpleTodo::Repository::InMemory::PersonRepository.new }
    
    it "should have no entries to begin with" do
      subject.count.must_equal 0
    end
    
    describe "with a new person" do
      
      before do
        @person = Person.new({ email: "sam@somewhere.com" })
        @result = subject.save( @person )
      end
      
      it "should have 1 now" do
        subject.count.must_equal 1
      end
      
      it "should return the person" do
        @result.must_equal @person
      end
      
      describe "with an existing person" do
        
        before do
          @result = subject.save( @person )
        end
        
        it "should still only have 1" do
          subject.count.must_equal 1
        end
        
      end
      
      describe "with another new person" do
        
        before do
          @person_2 = Person.new({ email: "sara@somewhere.com" })
          @result   = subject.save( @person_2 )
        end
        
        it "should now have 2 persons" do
          subject.count.must_equal 2
        end
        
      end
      
    end
    
  end
  
  describe "#find_by_email" do
    
    subject { SimpleTodo::Repository::InMemory::PersonRepository.new }
    
    before do
      @jim  = Person.new({ email: "jim@aol.com" })
      @sara = Person.new({ email: "sara@mycompany.com" })
      subject.save( @jim )
      subject.save( @sara )
    end
    
    it "should have 2 people in the repo" do
      subject.count.must_equal 2
    end
    
    it "should return nil if trying to find by nil email" do
      subject.find_by_email(nil).must_be_nil
    end
    
    it "should return nil if trying to find by a blank email" do
      subject.find_by_email("  ").must_be_nil
    end
    
    it "should return nil if trying to find by an email address that does not exist" do
      subject.find_by_email("someelse@somewhere.com").must_be_nil
    end
    
    it "should return jim if searching on identical email address for jim" do
      subject.find_by_email("jim@aol.com").must_equal @jim
    end
    
    it "should return jim if searching on a different case email address for jim" do
      subject.find_by_email("JIM@Aol.com").must_equal @jim
    end
    
  end
  
  describe "#exists?" do
    
    subject { SimpleTodo::Repository::InMemory::PersonRepository.new }
    
    before do
      @jim = Person.new({ email: "jim@aol.com" })
      subject.save( @jim )
    end
    
    it "should exists if email matches" do
      subject.exists?( email: "jim@aol.com" ).must_equal( true )
    end
    
    it "should not exist if email does not match" do
      subject.exists?( email: "someone@somewhere" ).must_equal( false )
    end
    
    it "should not exist if no attributes are provided" do
      subject.exists?( {} ).must_equal( false )
    end
    
  end
  
  describe "#clear" do
    
    subject { SimpleTodo::Repository::InMemory::PersonRepository.new }
    
    it "should no error if repository is empty" do
      subject.clear
      subject.count.must_equal( 0 )
    end
    
    describe "with people" do
      
      before do
        subject.save( Person.new( email: "person1@somewhere.com") )
        subject.save( Person.new( email: "person2@somewhere.com") )
      end
      
      it "should have 2 people" do
        subject.count.must_equal( 2 )
      end
      
      describe "calling clear" do
        
        it "should clear out the repository" do
          subject.clear
          subject.count.must_equal( 0 )
        end
        
      end
      
    end
    
  end  
  
  
end