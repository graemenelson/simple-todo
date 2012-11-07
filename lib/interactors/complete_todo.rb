module SimpleTodo
  module Interactors
    class CompleteTodo < Base
      
      include Mixins::LookupPerson
      include Mixins::EnsurePerson  
        
      attr_reader :todo
        
      def initialize( person_repository, person_uuid )
        self.person_repository = person_repository
        self.person_uuid       = person_uuid
      end
      
      def call( attributes = {} )
        reset_response
        extract_attributes( attributes )
        ensure_person!
        ensure_todo_uuid!
        unless response.errors?
          todo = person.todos.select{|todo| todo_uuid == todo.uuid }.first
          if todo
            todo.completed_at = current_time
            person_repository.save( person )
            @todo   = todo
          else
            response.errors.add(:todo_uuid, "is invalid.")
          end
        end
        response
      end
      
      private
      
      attr_reader :todo_uuid
      
      def extract_attributes( attributes = {} )
        @todo_uuid = attributes[:todo_uuid]
      end
      
      def ensure_todo_uuid!
        response.errors.add(:todo_uuid, "is required.") unless todo_uuid
      end
      
    end
  end
end