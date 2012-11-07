require './spec/unit/spec_helper'

describe SimpleTodo::Interactors::CompleteTodo do
  
  before do
    @person_repository = MiniTest::Mock.new
    @person_uuid       = SecureRandom.uuid
  end
  
  describe "#call" do
    
    describe "with missing person_uuid" do
      
      subject { SimpleTodo::Interactors::CompleteTodo.new( @person_repository, nil) }
      
      before do
        @person_repository.expect( :find_by_uuid, nil, [nil] )
        @response = subject.call({ todo_uuid: SecureRandom.uuid })
      end
      
      it "should have an error on person" do
        @response.errors.on(:person).must_equal( ["is required."] )
      end
      
      it "should call the expected methods on @person_repository" do
        @person_repository.verify
      end
      
    end
    
    describe "with missing todo uuid" do
      
      subject { SimpleTodo::Interactors::CompleteTodo.new( @person_repository, @person_uuid) }
      
      before do
        person = OpenStruct.new
        @person_repository.expect( :find_by_uuid, person, [@person_uuid] )
        @response = subject.call({})
      end
      
      it "should return a response with an error on todo_uuid" do        
        @response.errors.on(:todo_uuid).must_equal( ["is required."] )
      end
      
      it "should call the expected methods on @repository" do
        @person_repository.verify
      end
      
    end
    
    describe "with todo uuid that does not belong to person" do
      
      subject { SimpleTodo::Interactors::CompleteTodo.new( @person_repository, @person_uuid) }
      
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
    
    describe "with exisitng todo uuid for given person" do
      
      subject { SimpleTodo::Interactors::CompleteTodo.new( @person_repository, @person_uuid) }
      
      before do
        @todo   = SimpleTodo::Entity::Todo.new( uuid: SecureRandom.uuid, title: "my todo item")
        @person = OpenStruct.new( todos: [ @todo ] )
        @person_repository.expect( :find_by_uuid, @person, [@person_uuid] )
        @person_repository.expect( :save, @person, [@person] )
        @response = subject.call({ todo_uuid: @todo.uuid })
      end
      
      it "should return a response with no errors" do
        @response.errors?.must_equal( false )
      end
      
      it "should assign todo item to the interactor" do
        subject.todo.must_equal( @todo )
      end
      
      it "should have marked the todo item as completed" do
        subject.todo.completed?.must_equal( true )
      end
      
      it "should call the expected methods on @person_repository" do
        @person_repository.verify
      end
      
    end
    
  end
  
end