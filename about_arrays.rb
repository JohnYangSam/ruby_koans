require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutArrays < EdgeCase::Koan
  def test_creating_arrays
    empty_array = Array.new
    assert_equal Array, empty_array.class
    assert_equal 0, empty_array.size
  end

  def test_array_literals
    array = Array.new
    assert_equal [], array

    array[0] = 1
    assert_equal [1], array

    array[1] = 2
    assert_equal [1, 2], array

	#pushing on pushes the full piece as one
    array << 333
    assert_equal [1, 2, 333], array
  end

  def test_accessing_array_elements
    array = [:peanut, :butter, :and, :jelly]

    assert_equal :peanut, array[0]
    assert_equal :peanut, array.first
    assert_equal :jelly, array[3]
    assert_equal :jelly, array.last
    assert_equal :jelly, array[-1]
    assert_equal :butter, array[-3]
  end

  def test_slicing_arrays
    array = [:peanut, :butter, :and, :jelly]

    assert_equal [:peanut], array[0,1] #first is the start index second is the number of pieces to move in
    assert_equal [:peanut, :butter], array[0,2]
    assert_equal [:and, :jelly], array[2,2]
    assert_equal [:and, :jelly], array[2,20] #overflow on bounds is ignored

	# Explanation:
	# When array indexing as in arr[4] you are indexing out of bounds
	# but when slicing, you are treating that place just before the index
	# as the start of the slice
	# for instance:
	# [:peanut, :butter, :and, :jelly ]
	# 0		   1		2     3      4     <= slicing positions
	#
	# Meaning that 4 is just inside the array when slicing, but outside of it when indexing


    assert_equal [], array[4,0]		#these each are
    assert_equal [], array[4,100]
    assert_equal nil, array[5,0]
  end

  def test_arrays_and_ranges
    assert_equal Range, (1..5).class
    assert_not_equal [1,2,3,4,5], (1..5) #because a Range is not an Array
    assert_equal [1,2,3,4,5], (1..5).to_a
    assert_equal [1,2,3,4], (1...5).to_a #Triple elipses excludes the top term
  end

  def test_slicing_with_ranges
    array = [:peanut, :butter, :and, :jelly]

    assert_equal [:peanut, :butter, :and], array[0..2]
    assert_equal [:peanut, :butter], array[0...2]
    assert_equal [:and, :jelly], array[2..-1] #Watch your start place
  end

  def test_pushing_and_popping_arrays
    array = [1,2]
    array.push(:last)

    assert_equal [1,2,:last], array

    popped_value = array.pop
    assert_equal :last, popped_value
    assert_equal [1,2], array
  end

  def test_shifting_arrays
    array = [1,2]
	#unshift prepends the object to self
	#push onto front equivalent
    array.unshift(:first)

    assert_equal [:first, 1, 2], array

	#shift takes pops from the front
    shifted_value = array.shift
    assert_equal :first, shifted_value
    assert_equal [1,2], array
  end

end
