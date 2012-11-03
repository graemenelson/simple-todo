module SimpleTodo
  module Entity
    class Base
      
      attr_reader :uuid
            
      def initialize(attributes = {})
        attributes.each do |attr, value|
          send("#{attr}=", value)
        end
      end
      
      private 
      
      attr_writer :uuid
      
    end
  end
end