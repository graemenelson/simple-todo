module SimpleTodo
  module Repository
    module InMemory
        
      class PersonRepository
        
        def save(person)
          return person if people.include?(person)
          people.push(person)
          person
        end
        
        def find_by_email(email)
          return nil unless email
          email = email.downcase
          people.select{|person| email == person.email}.first
        end
        
        def exists?(attributes = {})
          found = find_by_email( attributes[:email] )
          found ? true : false
        end
        
        def count
          people.size
        end
        
        def clear
          @people = []
        end
                
        private
        
        def people
          @people ||= []
        end
        
      end
        
    end
  end
end