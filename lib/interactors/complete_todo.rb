module SimpleTodo
  module Interactors
    class CompleteTodo < Base
        
      def initialize( person_repository, person_uuid )
        @person_repository = person_repository
        @person_uuid       = person_uuid
      end
      
      def call( attributes = {} )
        reset_response
        extract_attributes( attributes )
        ensure_todo_uuid!
        unless response.errors?
          todo = person.todos.select{|todo| todo_uuid == todo.uuid }.first
          if todo
            todo.completed_at = current_time
            response.entity   = todo
          else
            response.errors.add(:todo_uuid, "is invalid.")
          end
        end
        response
      end
      
      private
      
      attr_reader :person_repository, :person_uuid, :todo_uuid
      
      def person
        @person ||= person_repository.find_by_uuid( person_uuid )
      end
      
      def extract_attributes( attributes = {} )
        @todo_uuid = attributes[:todo_uuid]
      end
      
      def ensure_todo_uuid!
        response.errors.add(:todo_uuid, "is required.") unless todo_uuid
      end
      
    end
  end
end