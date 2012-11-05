module SimpleTodo
  module Interactors
    module Mixins
      module LookupPerson
   
        def self.included( base )
          base.send( :include, InstanceMethods )
        end
        
        module InstanceMethods
      
          private
          
          attr_accessor :person_repository, :person_uuid
          
          def person
            @person ||= person_repository.find_by_uuid( person_uuid )
          end
          
        end
        
        
      end
    end
  end
end