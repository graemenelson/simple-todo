module SimpleTodo
  module Interactors
    class Response
                
        
      attr_accessor :entity
      attr_reader   :errors
        
      def initialize
        @errors = Errors.new
      end
        
      def errors?
        errors.any?
      end
                 
    end    
  end
end

require_relative 'response/errors'