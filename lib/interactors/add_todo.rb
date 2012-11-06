module SimpleTodo
  module Interactors
    class AddTodo < Base
      
      include Mixins::LookupPerson
      include Mixins::EnsurePerson
        
      attr_reader :todo  
        
      def initialize( person_repository, person_uuid )
        self.person_repository = person_repository
        self.person_uuid       = person_uuid
      end
      
      def call(attributes = {})
        reset_response
        extract_attributes( attributes )
        ensure_person!
        ensure_title!
        unless response.errors?
          @todo = person.add_todo( SimpleTodo::Entity::Todo.new( uuid: generate_uuid, title: title, completed_at: nil ) )
          person_repository.save(person)
        end
        response
      end
      
      private
      
      attr_reader :title
      
      def extract_attributes( attributes = {} )
        @title = attributes[:title]
      end
      
      def ensure_title!
        response.errors.add(:title, "is required.") unless title
      end
      
    end
  end
end