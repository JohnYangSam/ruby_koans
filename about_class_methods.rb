require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutClassMethods < EdgeCase::Koan
  class Dog
  end

  def test_objects_are_objects
    fido = Dog.new
    assert_equal true, fido.is_a?(Object)
  end

  def test_classes_are_classes
    assert_equal true, Dog.is_a?(Class)
  end

  # Classes are objects as well
  def test_classes_are_objects_too
    assert_equal true, Dog.is_a?(Object)
  end

  # Both objects and classes have methods

  def test_objects_have_methods
    fido = Dog.new
    assert fido.methods.size > 0
  end

  def test_classes_have_methods
    assert Dog.methods.size > 0
  end

  def test_you_can_define_methods_on_individual_objects
    fido = Dog.new
    def fido.wag
      :fidos_wag
    end
    assert_equal :fidos_wag, fido.wag
  end

  def test_other_objects_are_not_affected_by_these_singleton_methods
    fido = Dog.new
    rover = Dog.new
    def fido.wag
      :fidos_wag
    end

	# Basically, adding a method to one object does not add it to all objects
    assert_raise(NoMethodError) do
      rover.wag
    end
  end

  # ------------------------------------------------------------------

  # Class versus instance method declaration

  # INSTANCE Declaration
  class Dog2
    def wag
      :instance_level_wag
    end
  end

  # CLASS Declaration
  def Dog2.wag
    :class_level_wag
  end

  def test_since_classes_are_objects_you_can_define_singleton_methods_on_them_too
    assert_equal :class_level_wag, Dog2.wag
  end

  def test_class_methods_are_independent_of_instance_methods
    fido = Dog2.new
    assert_equal :instance_level_wag, fido.wag
    assert_equal :class_level_wag, Dog2.wag
  end

  # ------------------------------------------------------------------

  # INSTANCE variables in the class definition
  class Dog
    attr_accessor :name
  end

  # CLASS variables - instance variables are not instantiated before they are assigned
  # For explanation involving class << self and how this is a shortcut for that:
  # http://stackoverflow.com/questions/2505067/class-self-idiom-in-ruby

  def Dog.name
    @name
  end

  def test_classes_and_instances_do_not_share_instance_variables
    fido = Dog.new
    fido.name = "Fido"
    assert_equal "Fido", fido.name
    assert_equal nil, Dog.name # nothing was set here
  end

  # ------------------------------------------------------------------

	
  # Defining a class method inside a class too!

  class Dog
    def Dog.a_class_method
      :dogs_class_method
    end
  end

  def test_you_can_define_class_methods_inside_the_class
    assert_equal :dogs_class_method, Dog.a_class_method
  end


  # ------------------------------------------------------------------

  # Classes return the last expression in the class statement
  # just like object or function definitions do

  LastExpressionInClassStatement = class Dog
                                     21
                                   end

  def test_class_statements_return_the_value_of_their_last_expression
    assert_equal 21, LastExpressionInClassStatement
  end

  # ------------------------------------------------------------------

  # self inside of a class object is an instance of that class
  SelfInsideOfClassStatement = class Dog
                                 self
                               end

  def test_self_while_inside_class_is_class_object_not_instance
    assert_equal true, Dog == SelfInsideOfClassStatement
  end

  # ------------------------------------------------------------------

  # Using self to define class methods within a class
  class Dog
    def self.class_method2
      :another_way_to_write_class_methods
    end
  end

  def test_you_can_use_self_instead_of_an_explicit_reference_to_dog
    assert_equal :another_way_to_write_class_methods, Dog.class_method2
  end

  # ------------------------------------------------------------------

  # Using the class << self process to add class methods. This can be used
  # to add multiple class methods in the closure
  class Dog
    class << self
      def another_class_method
        :still_another_way
      end

	  def try_this
		  :trying?
	  end
    end
  end

  def test_heres_still_another_way_to_write_class_methods
    assert_equal :still_another_way, Dog.another_class_method
	assert_equal :trying?, Dog.try_this;
  end

  # THINK ABOUT IT:
  #
  # The two major ways to write class methods are:
  #   class Demo
  #     def self.method
  #     end
  #
  #     class << self
  #       def class_methods
  #       end
  #     end
  #   end
  #
  # Which do you prefer and why?
  # Are there times you might prefer one over the other?

  # ------------------------------------------------------------------

  def test_heres_an_easy_way_to_call_class_methods_from_instance_methods
    fido = Dog.new
    assert_equal :still_another_way , fido.class.another_class_method
  end

end
