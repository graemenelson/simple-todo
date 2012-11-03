require './spec/integration/spec_helper'
require 'securerandom'

describe "Todo" do
  
  Person = SimpleTodo::Entity::Person
  Todo   = SimpleTodo::Entity::Todo
  
  before do
    @person_repository = SimpleTodo::Repository.for(:person)
    @person_repository.clear
    
    @jim  = Person.new( uuid: SecureRandom.uuid, email: "jim@aol.com" )
    @sara = Person.new( uuid: SecureRandom.uuid, email: "sara@gmail.com" )      
    @person_repository.save( @jim )
    @person_repository.save( @sara )
  end
  
  it "should have 2 people in the repository" do
    @person_repository.count.must_equal( 2 )
  end
  
  it "jim should have no todos" do
    @jim.todos.must_be_empty
  end
  
  it "sara should have no todos" do
    @sara.todos.must_be_empty
  end
  
  describe "adding a todo" do
  
    describe "with jim" do
      
      subject { SimpleTodo::Interactors::AddTodo.new( @person_repository, @jim.uuid ) }

      describe "with a title" do      
        
        before do
          @response = subject.call( title: "this is my next todo" )
        end
        
        it "should have no errors on response" do
          @response.errors?.must_equal( false )
        end
        
        it "should assign the todo as the response entity" do
          @response.entity.title.must_equal( "this is my next todo" )
          @response.entity.uuid.wont_be_nil
          @response.entity.completed_at.must_be_nil
        end
        
        it "should add a todo with the given title to @jim" do
          @jim.todos.count.must_equal( 1 )
          @jim.todos.first.title.must_equal( "this is my next todo" )
        end
        
      end
    
      describe "with no title" do
      
        before do
          @response = subject.call( {} )          
        end
        
        it "should have errors on response" do
          @response.errors?.must_equal( true )
        end
        
        it "should have an error on title" do
          @response.errors.on(:title).must_equal( ["is required."] )
        end
        
        it "jim should still have no todo items" do
          @jim.todos.must_be_empty
        end
      
      end
      
    end
    

    
  end
  
end