require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutExceptions < EdgeCase::Koan

  class MySpecialError < RuntimeError
  end

  # RuntimeError to Exception to Object hierarchy
  def test_exceptions_inherit_from_Exception
    assert_equal RuntimeError, MySpecialError.ancestors[1]
    assert_equal StandardError, MySpecialError.ancestors[2]
    assert_equal Exception, MySpecialError.ancestors[3]
    assert_equal Object, MySpecialError.ancestors[4]
  end

  def test_rescue_clause
    result = nil
    begin
      fail "Oops" # Fail is a system method that raises an exception
    rescue StandardError => ex
      result = :exception_handled
    end

    assert_equal :"exception_handled", result
	# Both of these below are true becasue of the climb up the hierarchy
    assert_equal true, ex.is_a?(StandardError), "Should be a Standard Error"
    assert_equal true, ex.is_a?(RuntimeError),  "Should be a Runtime Error"

    assert RuntimeError.ancestors.include?(StandardError),
      "RuntimeError is a subclass of StandardError"

    assert_equal "Oops", ex.message
  end

  def test_raising_a_particular_error
    result = nil
    begin
      # ***** 'raise' and 'fail' are synonyms *****
      raise MySpecialError, "My Message"
    rescue MySpecialError => ex
      result = :exception_handled
    end

    assert_equal :exception_handled, result
    assert_equal "My Message", ex.message
  end

  def test_ensure_clause
    result = nil
    begin
      fail "Oops"
    rescue StandardError => ex
      # no code here
    ensure
      result = :always_run
    end

    assert_equal :always_run, result
  end

  # Raising your own exception
  # Sometimes, we must know about the unknown
  def test_asserting_an_error_is_raised
    # A do-end is a block, a topic to explore more later
    assert_raise(AboutExceptions::MySpecialError) do
      raise MySpecialError.new("New instances can be raised directly.")
    end
  end

  # Standard:
  #
  # begin
  #   # Exception throwing code here
  # rescue Exception => ex
  #   # Exception is caught in ex and can be handled here
  # ensure
  #	  # always execute this
  # end
	#
	# We can also use the catch and throw clause below to pop
	# out of inner loops stopping execution at throw and and
	# unwinding to the place where the catch with the appropriate
	# symbol was placed.
  #

	catch(:error_test) do
		for i in 0...5 do
			if(i == 3)
				throw :error_test
			end
		end
	end


	# Example of using begin...rescue in order to continue
	# on a loop when an exception is raised. This pattern
	# can be used for catching timeouts on scraping especially
	# when an exception instead of a standard condition is raised

	for i in (0..5) do
		begin
			if (i == 3)
				raise RuntimeError.new("Hit Three");
			end
#			puts i
		rescue RuntimeError => e
#			puts(e.message);
			next # This next is optional here
		end
	end

end
