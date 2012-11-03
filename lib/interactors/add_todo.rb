module SimpleTodo
  module Interactors
    class AddTodo < Base
        
      def initialize( person_repository, person_uuid )
        @person_repository = person_repository
        @person_uuid       = person_uuid
      end
      
      def call(attributes = {})
        reset_response
        extract_attributes( attributes )
        ensure_title!
        unless response.errors?
          todo = person.add_todo( SimpleTodo::Entity::Todo.new( uuid: generate_uuid, title: title, completed_at: nil ) )
          person_repository.save(person)
          response.entity = todo
        end
        response
      end
      
      private
      
      attr_reader :person_repository, :person_uuid, :title
      
      def extract_attributes( attributes = {} )
        @title = attributes[:title]
      end
      
      def ensure_title!
        response.errors.add(:title, "is required.") unless title
      end
      
      def person
        @person ||= person_repository.find_by_uuid( person_uuid )
      end
      
    end
  end
end