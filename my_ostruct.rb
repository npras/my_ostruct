require 'ostruct'

class MyOStruct
  def method_missing1 name, *args, &blk
    if name.to_s =~ /=$/
      instance_eval <<-EOF
        def #{name}(value)
          @#{name.to_s.chop} = value
        end

        def #{name.to_s.chop}
          @#{name.to_s.chop}
        end
      EOF
      self.send(name, *args)
    else
      nil
    end
  end

  def method_missing name, *args, &blk
    if name.to_s =~ /=$/
      MyOStruct.define_dynamic_method name
      self.send name, *args
    else
      nil
    end
  end

  def self.define_dynamic_method name
    define_method(name) do |args|
      instance_variable_set "@#{name.to_s.chop}", args
    end

    define_method(name.to_s.chop) do
      instance_variable_get "@#{name.to_s.chop}"
    end
  end
end

person = MyOStruct.new
#person = OpenStruct.new
person.name    = "John Smith"
p person.name
person.name    = "Bro Smith"
p person.name
person.numbers = [1, 2, 3, 55]
p person.numbers
#person.age     = 70
#person.pension = 300

p person.methods false
p person.instance_variables
