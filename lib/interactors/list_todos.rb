module SimpleTodo
  module Interactors
    #
    # Responsible for loading all the active todos
    # for the given person_uuid.
    #
    class ListTodos < Base
      
      include Mixins::LookupPerson
      include Mixins::EnsurePerson
      
      attr_reader :todos
      
      def initialize( person_repository, person_uuid )
        @person_repository = person_repository
        @person_uuid       = person_uuid
      end
      
      def call(attributes = {})
        reset_response
        extract_attributes( attributes )
        ensure_person!
        unless response.errors?
          @todos = paginate_todos_for_person
        end
        response
      end
      
      private
      
      attr_reader :page, :page_size
      
      def extract_attributes( attributes = {} )
        @page       = attributes.fetch( :page, nil )
        @page_size  = attributes.fetch( :page_size, nil )        
      end
      
      # this is a very simple pagination, and it probably
      # won't work for all cases.  once we start experiencing 
      # issues, we can move to a Pagination class.
      def paginate_todos_for_person
        persons_todos = person.todos
        if page && page_size          
          persons_todos = persons_todos.slice(index_for_pagination, page_size)
        end
        persons_todos || []
      end
      
      def index_for_pagination
        return 0 if page == 1
        ((page - 1) * page_size)
      end
      
    end
  end
end