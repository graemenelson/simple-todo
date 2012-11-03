require './spec/unit/spec_helper'
require 'securerandom'

describe SimpleTodo::Interactors::CompleteTodo do
  
  before do
    @person_repository = MiniTest::Mock.new
    @person_uuid       = SecureRandom.uuid
  end
  
  describe "#call" do
    
    subject { SimpleTodo::Interactors::CompleteTodo.new( @person_repository, @person_uuid) }
    
    describe "with missing uuid" do
      
      it "should return a response with an error on todo_uuid" do
        response = subject.call({})
        response.errors.on(:todo_uuid).must_equal( ["is required."] )
      end
      
    end
    
    describe "with uuid that does not belong to person" do
      
      before do
        @person = OpenStruct.new( todos: [ SimpleTodo::Entity::Todo.new( uuid: SecureRandom.uuid, title: "my todo item") ] )
        @person_repository.expect( :find_by_uuid, @person, [@person_uuid] )
        @response = subject.call({ todo_uuid: "someotheruuid" }) 
      end
      
      it "should return a response with an error on todo_uuid" do
        @response.errors.on(:todo_uuid).must_equal( ["is invalid."] )
      end
      
      it "should call all the expected methods on @person_repository" do
        @person_repository.verify
      end
      
    end
    
    describe "with exisitng uuid for given person" do
      
      before do
        @todo   = SimpleTodo::Entity::Todo.new( uuid: SecureRandom.uuid, title: "my todo item")
        @person = OpenStruct.new( todos: [ @todo ] )
        @person_repository.expect( :find_by_uuid, @person, [@person_uuid] )
        @response = subject.call({ todo_uuid: @todo.uuid })
      end
      
      it "should return a response with no errors" do
        @response.errors?.must_equal( false )
      end
      
      it "should return a todo item as the response entity" do
        @response.entity.must_equal( @todo )
      end
      
      it "should have marked the todo item as completed" do
        @response.entity.completed?.must_equal( true )
      end
      
      it "should call the expected methods on @person_repository" do
        @person_repository.verify
      end
      
    end
    
  end
  
end