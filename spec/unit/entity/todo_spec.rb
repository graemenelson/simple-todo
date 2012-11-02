require './spec/unit/spec_helper'

describe SimpleTodo::Entity::Todo do
  
  describe "#new" do
    
    it "should be able to create a todo with a title" do
      todo = SimpleTodo::Entity::Todo.new( title: "My new task" )
      todo.title.must_equal "My new task"
    end
    
  end
  
end