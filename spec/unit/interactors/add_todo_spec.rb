require './spec/unit/spec_helper'

describe SimpleTodo::Interactors::AddTodo do
  
  describe "#call" do
    
    before do
      @repository   = MiniTest::Mock.new
      @person_uuid  = SecureRandom.uuid
    end
    
    describe "with missing person_uuid" do
      
      subject { SimpleTodo::Interactors::AddTodo.new( @repository, nil ) }
      
      before do
        @repository.expect( :find_by_uuid, nil, [nil] )
        @response = subject.call({ title: "my title" })
      end
      
      it "should return a response with error on person" do
        @response.errors.on(:person).must_equal( ["is required."] )
      end
      
      it "should call all the expected methods on @repository" do
        @repository.verify
      end
      
    end
    
    describe "with a missing title" do
      
      subject { SimpleTodo::Interactors::AddTodo.new( @repository, @person_uuid ) }
      
      before do
        person = OpenStruct.new
        @repository.expect( :find_by_uuid, person, [@person_uuid] )
        @response = subject.call({})
      end
      
      it "should return a response with an error on title" do
        @response.errors.on(:title).must_equal( ["is required."] )
      end
      
      it "should call all the expected methods on @repository" do
        @repository.verify
      end
      
    end
    
    describe "with a title" do
      
      subject { SimpleTodo::Interactors::AddTodo.new( @repository, @person_uuid ) }
      
      before do
        @todo   = OpenStruct.new
        @person = MiniTest::Mock.new        
        @person.expect( :add_todo, @todo, [SimpleTodo::Entity::Todo] )
        @repository.expect( :find_by_uuid, @person, [@person_uuid] )
        @repository.expect( :save, @person, [@person] )
        
        @response = subject.call( {title: "my next item to do"} )
      end
      
      it "should return a response with no errors" do
        @response.errors?.must_equal( false )
      end
      
      it "should assign the todo to the interactor" do
        subject.todo.must_equal( @todo )
      end
      
      it "should call all the expected methods on @repository" do
        @repository.verify
      end
      
      it "should call all the expected methods on @person" do
        @person.verify
      end
      
    end
    
  end
  
end