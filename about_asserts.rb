#!/usr/bin/env ruby
# -*- ruby -*-

require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutAsserts < EdgeCase::Koan

  # We shall contemplate truth by testing reality, via asserts.
  def test_assert_truth
    assert true                # This should be true
  end

  # Enlightenment may be more easily achieved with appropriate
  # messages.
  #
  # Messages can be attached
  def test_assert_with_message
    assert true, "A message"
  end

  # To understand reality, we must compare our expectations against
  # reality.
  #
  # == assert works
  def test_assert_equality
    expected_value = 2
    actual_value = 1 + 1

    assert expected_value == actual_value
  end

  # Some ways of asserting equality are better than others.
  #
  # assert_equals is better
  def test_a_better_way_of_asserting_equality
    expected_value = 2
    actual_value = 1 + 1

    assert_equal expected_value, actual_value
  end

  # Sometimes we will ask you to fill in the values
  #
  # You can do things literally
  def test_fill_in_values
    assert_equal 2, 1 + 1
  end
end
