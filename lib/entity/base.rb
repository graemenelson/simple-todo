module SimpleTodo
  module Entity
    class Base
      
      def initialize(attributes = {})
        attributes.each do |attr, value|
          send("#{attr}=", value)
        end
      end
      
    end
  end
end