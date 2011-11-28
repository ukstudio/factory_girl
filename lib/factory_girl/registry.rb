module FactoryGirl
  class Registry
    include Enumerable

    def initialize(name)
      @name  = name
      @items = {}
    end

    def add(item)
      item.names.each { |name| add_as(name, item) }
      item
    end

    def find(name)
      name_ = name.is_a?(Symbol) ? name : name.to_s.underscore.to_sym
      @items[name_] or raise ArgumentError.new("#{@name} not registered: #{name.to_s}")
    end

    def each(&block)
      @items.values.uniq.each(&block)
    end

    def [](name)
      find(name)
    end

    def registered?(name)
      @items.key?(name.to_sym)
    end

    def clear
      @items.clear
    end

    private

    def add_as(name, item)
      if registered?(name)
        raise DuplicateDefinitionError, "#{@name} already registered: #{name}"
      else
        @items[name.to_sym] = item
      end
    end
  end
end

