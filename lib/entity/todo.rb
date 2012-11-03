module SimpleTodo
  module Entity
    class Todo < Base
      
      attr_accessor :title, :completed_at
      
      def completed?
        completed_at ? true : false
      end
      
    end
  end
end