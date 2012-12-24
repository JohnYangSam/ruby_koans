require File.expand_path(File.dirname(__FILE__) + '/edgecase')

# Quick block overview:
#
# To make a Ruby block we enclose some code in {} or do .. end
#
# We can make a method that has a yield statement.
#
# Everytime the yield statement is called, the block is called.
# We can even pass parameters to the yield statement and pipe them down
# with |param1, param2, etc | in the block.
#
# Blocks can also be assigned in the function in the following way:
#
# def test(&block)
#	block.call
# end
#
# test {puts "Hello"}
#
# Such that & precedes the last method parameter and this last parameter
# is therefore assigned to the block passed to the method
#
#
# BEGIN and END special keywords:
#
# BEGIN { 
#	#Code to run as program is loading 
# }
#
# END {
#	#Code to run after program has finished executing
# }
#
# Blocks, Procs, and Lambdas
#
# Blocks are code snippets that can be passed in and used once
#
# Procs (i.e. Proc.New { } Where the block code goes inside, are like blocks
# that can be passed as full objects in the ( ) parens of a method. The key
# difference is that blocks are more "Ruby like" and Procs are more like
# standard closures that can also be saved as variables reused, put into
# hashes, etc.
#
# Lambdas are anonymous functions (i.e. methods) while Procs and blocks are code
# snippets, lambdas are like anonymous methods in other languages.
#
# Two differences between lambdas and procs
# 1) lambdas check arguments and throw and error if there is a problem where as Proc.new {} will just have nils
# 2) lambdas return a value to the method they are called in whereas Procs are full code snippets and return the
#	 entire method when they return.
#
#	 Also, Procs (passed in as objects) cannot have returns in them, but since lambdas are methods, they can.
#
# When we return, we can return two arguments with commas inbetween using a lambda. For a proc, we need to turn the
# two results into an array and use parallel assignment to get the arguments out if we are doing
# assignment.
#
# Treat Procs like blocks of code and lambdas like anonymous functions.
#
# To treat a method as a lambda (i.e. a method object) we can use the following.
#
#
# class Array
#	def iterate!(code)
#		self.each_with_index do |n, i|
#			self[i] = code.call(n);
#		end
#	end
# end
#
#  def square(n)
#	return n ** 2;
# end
#
# array = [1, 2, 3, 4]
#
# array.iterate!(method(:square))
#
# #This above code executes the square method as a lambda
#
# Good resource:
# http://www.robertsosinski.com/2008/12/21/understanding-ruby-blocks-procs-and-lambdas/
#
class AboutBlocks < EdgeCase::Koan
  def method_with_block
    result = yield
    result
  end

  def test_methods_can_take_blocks
    yielded_result = method_with_block { 1 + 2 }
    assert_equal 3, yielded_result
  end

  def test_blocks_can_be_defined_with_do_end_too
    yielded_result = method_with_block do 1 + 2 end
    assert_equal 3, yielded_result
  end

  # ------------------------------------------------------------------

  def method_with_block_arguments
    yield("Jim")
  end

  def test_blocks_can_take_arguments
    result = method_with_block_arguments do |argument|
      assert_equal "Jim", argument
    end
  end

  # ------------------------------------------------------------------

  def many_yields
    yield(:peanut)
    yield(:butter)
    yield(:and)
    yield(:jelly)
  end

  def test_methods_can_call_yield_many_times
    result = []
    many_yields { |item| result << item }
    assert_equal [:peanut, :butter, :and, :jelly], result
  end

  # ------------------------------------------------------------------

  # You can test for blocks using		block_given?
  def yield_tester
    if block_given?
      yield
    else
      :no_block
    end
  end

  def test_methods_can_see_if_they_have_been_called_with_a_block
    assert_equal :with_block, yield_tester { :with_block }
    assert_equal :no_block, yield_tester
  end

  # ------------------------------------------------------------------


  # Because the variable is defined in a block which is in the general scope
  # of its initial declaration (or so it seems) it can reach out and affect
  # that variable
  def test_block_can_affect_variables_in_the_code_where_they_are_created
    value = :initial_value
    method_with_block { value = :modified_in_a_block }
    assert_equal :modified_in_a_block, value
  end

  # Example of storing a lambda in a variable and then calling the lambda
  # from the variable as if the variable were a standard function
  def test_blocks_can_be_assigned_to_variables_and_called_explicitly
    add_one = lambda { |n| n + 1 }
    assert_equal 11, add_one.call(10) # Calling a lambda directly (as you would within a method)

    # Alternative calling sequence
    assert_equal 11, add_one[10]      # Another way to call a lambda -> notice the brackets
  end

  def test_stand_alone_blocks_can_be_passed_to_methods_expecting_blocks
    make_upper = lambda { |n| n.upcase }
    result = method_with_block_arguments(&make_upper) # A lambda can be passed like a block if you use a &.
    assert_equal "JIM", result
  end

  # ------------------------------------------------------------------

  def method_with_explicit_block(&block)
    block.call(10)
  end

  def test_methods_can_take_an_explicit_block_argument
    assert_equal 20, method_with_explicit_block { |n| n * 2 }

    add_one = lambda { |n| n + 1 }
    assert_equal 11, method_with_explicit_block(&add_one)
  end

end
