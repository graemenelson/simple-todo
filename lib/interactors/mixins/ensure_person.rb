module SimpleTodo
  module Interactors
    module Mixins
      #
      # Responsible for providing #ensure_person!.
      # It depends on access to response and person
      # attributes.
      #
      module EnsurePerson
        
        def self.included( base )
          base.send( :include, InstanceMethods )
        end
        
        module InstanceMethods

          private
        
          def ensure_person!
            response.errors.add( :person, "is required." ) unless person
          end
          
        end
      
      end   
    end
  end
end