module SimpleTodo
  module Interactors
    class Base
   
      private
        
      attr_reader :response
        
      def reset_response
        @response = Response.new
      end
      
    end
  end
end