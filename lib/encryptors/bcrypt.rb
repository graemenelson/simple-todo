require 'bcrypt'

module SimpleTodo
  module Encryptors
    class BCrypt
      
      # takes a class that response to:
      # 
      # #create(string, options = {})
      # #new(encrypted_string) 
      # #==(password)
      #
      def initialize(bcrypt = ::BCrypt::Password, cost = 10) 
        @bcrypt = bcrypt
        @cost   = cost
      end
        
      def salt
        @salt ||= generate_random_salt
      end
      
      # encrypts the given password with either
      # the given salt, or the default salt.
      def encrypt(password, salt = self.salt)
        generate_encrypted_hash(password, salt)
      end
      
      def match?(encrypted_password, password, salt = self.salt)
        bcrypt.new(encrypted_password) == password_with_salt(password, salt)
      end
      
      private
      
      attr_reader :bcrypt, :cost
      
      def generate_random_salt
        (0...8).map{65.+(rand(26)).chr}.join
      end
      
      def generate_encrypted_hash(password, salt)
        bcrypt.create( password_with_salt(password, salt), cost: cost )
      end
      
      def password_with_salt(password, salt)
        "#{salt}--#{password}"
      end
        
    end
  end
end