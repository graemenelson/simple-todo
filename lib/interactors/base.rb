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
      
      def current_time
        # NOTE: later on we can inject the class that will get us
        # the current time, this way we handle timezones. For now,
        # Time.now will work.
        Time.now
      end
      
    end
  end
end