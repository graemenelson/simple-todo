require './spec/unit/spec_helper'
require 'securerandom'

describe SimpleTodo::Interactors::AddTodo do
  
  describe "#call" do
    
    before do
      @repository   = MiniTest::Mock.new
      @person_uuid  = SecureRandom.uuid
    end
    
    describe "with a missing title" do
      
      subject { SimpleTodo::Interactors::AddTodo.new( @repository, @person_uuid ) }
      
      it "should return a response with an error on title" do
        response = subject.call({})
        response.errors.on(:title).must_equal( ["is required."] )
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
      
      it "should assign the todo as the entity" do
        @response.entity.must_equal( @todo )
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