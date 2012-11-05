require './spec/unit/spec_helper'

describe SimpleTodo::Interactors::ListTodos do

  describe "#call" do
    
    before do
      @repository   = MiniTest::Mock.new     
      @person_uuid  = SecureRandom.uuid 
    end
    
    
    describe "with missing person_uuid" do
      
      subject { SimpleTodo::Interactors::ListTodos.new( @repository, nil ) }
      
      before do
        @repository.expect( :find_by_uuid, nil, [nil] )
        @response = subject.call
      end
      
      it "should have errors on person" do
        @response.errors.on(:person).must_equal( ["is required."] )
      end
      
    end
    
    describe "with uuid for valid person" do
      
      subject { SimpleTodo::Interactors::ListTodos.new( @repository, @person_uuid ) }

      before do
        @todos  = (1..20).to_a
        @person = OpenStruct.new( todos: @todos )
        @repository.expect( :find_by_uuid, @person, [@person_uuid] )        
      end  
            
      describe "with no attributes to the call" do
        
        before do
          @response = subject.call
        end

        it "should not have any errors on @response" do
          @response.errors?.must_equal( false )
        end
      
        it "should set the todos attribute to all of the person's todos" do
          subject.todos.must_equal( @todos )
        end
      
        it "should call all the expected methods on @repository" do
          @repository.verify
        end
        
      end
      
      describe "with attributes: page = 1 and page_size = 5" do
        
        before do
          @response = subject.call( page: 1, page_size: 5 )
        end
        
        it "should not have any errors on @response" do
          @response.errors?.must_equal( false )
        end
        
        it "should return only 1 through 5 of the todos" do
          subject.todos.must_equal( [1, 2, 3, 4, 5] )
        end
        
        it "should call all the expected methods on @repository" do
          @repository.verify
        end
        
      end
      
      describe "with attributes: page = 2 and page_size = 5" do
        
        before do
          @response = subject.call( page: 2, page_size: 5 )
        end
        
        it "should not have any errors on @response" do
          @response.errors?.must_equal( false )
        end
        
        it "should return 6 through 10" do
          subject.todos.must_equal( [6, 7, 8, 9, 10] )
        end
        
        it "should call all the expected methods on @repository" do
          @repository.verify
        end
        
      end
      
      describe "with attributes outside of the page range: page = 5 and page_size = 5" do
        
        before do
          @response = subject.call( page: 5, page_size: 5 )
        end

        it "should not have any errors on @response" do
          @response.errors?.must_equal( false )
        end
        
        it "should return an empty list" do
          subject.todos.must_be_empty
        end
        
        it "should not return a nil value" do
          subject.todos.wont_be_nil
        end
        
        it "should call all the expected methods on @repository" do
          @repository.verify
        end        
        
        
      end
      
    end

  end
  
end