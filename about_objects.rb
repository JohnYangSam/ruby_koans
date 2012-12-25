require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutObjects < EdgeCase::Koan
  def test_everything_is_an_object
    assert_equal true, 1.is_a?(Object)
    assert_equal true, 1.5.is_a?(Object)
    assert_equal true, "string".is_a?(Object)
    assert_equal true, nil.is_a?(Object)
    assert_equal true, Object.is_a?(Object)
  end

  def test_objects_can_be_converted_to_strings
    assert_equal "123", 123.to_s
    assert_equal "", nil.to_s
  end

  def test_objects_can_be_inspected
    assert_equal "123", 123.inspect
    assert_equal "nil", nil.inspect
  end

  def test_every_object_has_an_id
    obj = Object.new
    assert_equal Fixnum, obj.object_id.class
  end

  def test_every_object_has_different_id
    obj = Object.new
    another_obj = Object.new
    assert_equal true, obj.object_id != another_obj.object_id
  end

  def test_some_system_objects_always_have_the_same_id
    assert_equal false.object_id, false.object_id
    assert_equal true.object_id, true.object_id
    assert_equal nil.object_id, nil.object_id
  end

  def test_small_integers_have_fixed_ids
    assert_equal 1, 0.object_id
    assert_equal 3, 1.object_id
    assert_equal 201, 100.object_id  # +1
	assert_equal 203, 101.object_id; # +2
	assert_equal 205, 102.object_id; # +3
	assert_equal 207, 103.object_id; # +4

	assert_equal 409, 204.object_id; #+2 +5
	assert_equal 429, 214.object_id; #+2+3+5

    # THINK ABOUT IT:
    # What pattern do the object IDs for small integers follow?
	#
	# pattern is an Fixnum_id = (2 * Fixnum) + 1
	# See below for details. Essentially Ruby fixnums are stored in binary
	# using 31 of 32 bits on a 32 bit machine. The extra bit is used for
	# the id. For instance:
	#
	# 4 represented in binary:
	# 00000000 00000000 00000000 00000100
	#
	# To get the ID we add a 1 to the end by shifting up <<1
	# 00000000 00000000 00000000 00001001
	#
	# Now we have 9 which is the object_id for the Fixnum 4.
	# Therefore, when the 32nd bit is 1 the interpreter knows to
	# treat the bits as an id. The language only needs to bit shift
	# to the right to simultaneously, minus 1 and the divide by 2
	# and derive the Fixnum value from the Fixnum object_id
	#
	#See this post for more information;
	# http://www.sarahmei.com/blog/2009/04/21/object-ids-and-fixnums/
	#
  end

  def test_clone_creates_a_different_object
    obj = Object.new
    copy = obj.clone

    assert_equal true, obj           != copy
    assert_equal true, obj.object_id != copy.object_id
  end
end
