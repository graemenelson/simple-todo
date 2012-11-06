module SimpleTodo
  module Interactors
    class AuthenticatePerson < Base
   
      attr_reader :person
   
      def initialize(repository, encryptor = SimpleTodo::Encryptors::BCrypt.new)
        @repository = repository
        @encryptor  = encryptor
      end
      
      def call(attributes = {})
        reset_response
        extract_attributes!( attributes )
        person = repository.find_by_email( email )
        if person && valid_password_for?( person )
          @person = person
        else
          response.errors.add( :login, "Invalid email and/or password." )
        end
        response
      end
      
      private
      
      attr_reader :repository, :encryptor, :email, :password
      
      def extract_attributes!(attributes)
        @email    = normalize_email( attributes.fetch( :email, "" ) )
        @password = attributes.fetch( :password, "" )
      end
      
      def normalize_email(email)
        email.strip.downcase
      end
      
      def valid_password_for?(person)
        encryptor.match?( person.encrypted_password, password, person.salt )
      end
      
    end
  end
end