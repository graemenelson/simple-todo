module SimpleTodo
  module Entity
    class Person < Base
      
      attr_accessor :email, :salt, :encrypted_password
      
    end
  end
end