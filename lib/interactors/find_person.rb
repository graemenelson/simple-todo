module SimpleTodo
  module Interactors
    class FindPerson < Base
      
      attr_reader :person
      
      def initialize( person_repository )
        @person_repository = person_repository
      end
      
      def call(attributes = {})
        reset_response
        extract_attributes(attributes)
        ensure_uuid!
        unless response.errors?
          person = person_repository.find_by_uuid(uuid)
          if person
            @person = person
          else
            response.errors.add( :uuid, "was not found." )
          end
        end
        response
      end
      
      private
      
      attr_reader :person_repository, :uuid
      
      def extract_attributes(attributes)
        @uuid = attributes.fetch(:uuid, nil)
      end
      
      def ensure_uuid!
        response.errors.add( :uuid, "is required." ) unless uuid
      end
      
    end
  end
end