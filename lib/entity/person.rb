module SimpleTodo
  module Entity
    class Person < Base
      
      attr_accessor :email, :salt, :encrypted_password
      
      def todos
        _todos.clone
      end
      
      def add_todo(todo)
        _todos.push( todo )
        todo        
      end
      
      private
      
      def _todos
        @todos ||= []
      end
      
    end
  end
end