module SimpleTodo
  module Repository
    
    class MissingConfigurationException < StandardError; end
    class MissingRepositoryException < StandardError; end

    # Looks up the appropriate repository based on the entity which is any object
    # that can be converted to a symbol.  For example, "person" would look up
    # a repository for :person key.
    #
    # @raises MissingConfigurationException if there's no configuration
    # @raises MissingRepositoryException if theres's no repository for the given entity        
    def self.for(entity)
      fail MissingConfigurationException, "please be sure to set the repository configuration" unless configuration      
      repository = configuration[entity.to_sym]
      fail MissingRepositoryException, "there was no repository setup for '#{entity}'" unless repository
      repository
    end
    
    # :nodoc:
    def self.clear_configuration
      @configuration = nil
    end
    
    # The configuration expects a hash matching entity, ie Person to it's 
    # repo. 
    #
    # For example,
    #
    # SimpleTodo::Repository.configuration( {person: MyPersonRepository.new} )
    def self.configuration(configuration = nil)
      if configuration
        @configuration = configuration
      end
      @configuration
    end
    
        
  end
end