require 'securerandom'

module SimpleTodo
  module Interactors
    class Base
   
      private
        
      attr_reader :response
        
      def reset_response
        @response = Response.new
      end
      
      def generate_uuid
        SecureRandom.uuid
      end
      
    end
  end
end