require 'forwardable'

module SimpleTodo
  module Interactors
    class Response
      
      class Errors
                      
        extend Forwardable                      
        def_delegators :@errors, :empty?, :each
        
        def initialize
          @errors = {}
        end
          
        def add(key, error)
          symbolized_key = key.to_sym
          errors[symbolized_key] ||= []
          errors[symbolized_key].push( error )
          self
        end
          
        def on(key)
          symbolized_key = key.to_sym
          errors[symbolized_key] || []
        end
          
        def any?
          !empty?
        end
          
        private
          
        def errors
          @errors
        end
          
      end      
      
    end
  end
end
