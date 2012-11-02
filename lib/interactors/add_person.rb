module SimpleTodo
  module Interactors
    # Adds a new person.
    #
    # If a person with the same email address already exists, an EmailAlreadyTaken
    # expection will be raised.
    class AddPerson < Base
      # Expects a repository, encryptor and attributes for creating
      # the new person.
      #
      # The repository must respond to:
      #    exists?(attributes)
      #    save(attributes)   
      #
      # The encryptor must respond to:
      #     salt -- returns a salt value
      #     encrypt(string) -- encrypts string with a salt, salt is created when the encryptor is instantiated
      #  
      # NOTE: would be nice to have defaults here, something like:
      #
      # def initialize(repository = Repository.for(:person), encryptor = Encryptor::BCrypt  )
      def initialize(repository, encryptor)
        @repository = repository
        @encryptor  = encryptor
      end
      
      # attempts to add the person with the given attributes.
      def call(attributes = {})
        reset_response
        extract_attributes(attributes)
        ensure_valid_email_address!
        ensure_valid_password!
        unless response.errors?
          salt = encryptor.salt
          person = Entity::Person.new( email: email, salt: encryptor.salt, encrypted_password: encryptor.encrypt(password) )
          repository.save( person )
          response.entity = person
        end        
        response
      end
      
      private
      
      # the following attributes should be private, there's no need to
      # expose them to the public API.
      attr_reader :repository, :encryptor, :email, :password
      
      def extract_attributes(attributes = {})
        @email    = normalize_email( attributes.fetch(:email, "") )
        @password = normalize_password( attributes.fetch(:password, "") )
      end
      
      def ensure_valid_email_address!
        response.errors.add(:email, "is required.") and return unless email.length > 0  
        response.errors.add(:email, "already exists." ) and return if repository.exists?( {email: email} )      
      end
      
      def ensure_valid_password!
        response.errors.add(:password, "is required.") and return unless password.length > 0
      end
      
      # strip extra whitespace, and downcase email
      def normalize_email(email)
        email.strip.downcase
      end
      
      def normalize_password(password)
        password.strip
      end
      
    end
  end
end