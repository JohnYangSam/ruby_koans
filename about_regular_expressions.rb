# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/edgecase')

# Notes:
# Ruby Regexp can be
# /pattern/
# or
# r%!pattern! # where ! is any type of delimiter
class AboutRegularExpressions < EdgeCase::Koan
  def test_a_pattern_is_a_regular_expression
    assert_equal Regexp, /pattern/.class
  end

  # returned matched substring on found
  def test_a_regexp_can_search_a_string_for_matching_content
    assert_equal "match", "some matching content"[/match/]
  end

  # return nil on missing
  def test_a_failed_match_returns_nil
    assert_equal nil, "some matching content"[/missing/]
  end

  # ------------------------------------------------------------------

  def test_question_mark_means_optional
	# The question mark means 0 or 1 of the preceding
    assert_equal 'ab', "abbcccddddeeeee"[/ab?/] 
    assert_equal "a", "abbcccddddeeeee"[/az?/]
  end

  def test_plus_means_one_or_more
    assert_equal "bccc", "abbcccddddeeeee"[/bc+/]
  end

  def test_asterisk_means_zero_or_more
    assert_equal "abb", "abbcccddddeeeee"[/ab*/]
    assert_equal "a", "abbcccddddeeeee"[/az*/]
    assert_equal "", "abbcccddddeeeee"[/z*/]

    # THINK ABOUT IT:
    #
    # When would * fail to match?
	# never, unless you are testing against something
	# that is not a string and throw a syntax error
  end

  # THINK ABOUT IT:
  #
  # We say that the repetition operators above are "greedy."
  #
  # Why?
  #
  # They take as many characters as they possibly can

  # ------------------------------------------------------------------

  # LEFT MOST MATCH WINS (even if the right most is greedier)
  def test_the_left_most_match_wins
    assert_equal "a", "abbccc az"[/az*/]
  end

  # ------------------------------------------------------------------

  def test_character_classes_give_options_for_a_character
    animals = ["cat", "bat", "rat", "zat"]
	#	[..] matches any single character in the brackets
    assert_equal ["cat", "bat", "rat"], animals.select { |a| a[/[cbr]at/] }
  end

  # \d shortcut for the digit character class
  def test_slash_d_is_a_shortcut_for_a_digit_character_class
    assert_equal "42", "the number is 42"[/[0123456789]+/]
    assert_equal "42", "the number is 42"[/\d+/]
  end

  def test_character_classes_can_include_ranges
    assert_equal "42", "the number is 42"[/[0-9]+/]
  end

  # \s is whitespace
  def test_slash_s_is_a_shortcut_for_a_whitespace_character_class
    assert_equal " \t\n", "space: \t\n"[/\s+/]
  end

  def test_slash_w_is_a_shortcut_for_a_word_character_class
    # NOTE:  This is more like how a programmer might define a word.
    assert_equal 'variable_1', "variable_1 = 42"[/[a-zA-Z0-9_]+/]
    assert_equal "variable_1", "variable_1 = 42"[/\w+/]
  end

  # '.' <period> is a shortcut for any non newline character
  def test_period_is_a_shortcut_for_any_non_newline_character
    assert_equal 'abc', "abc\n123"[/a.+/]
  end

  # use ^ inside the [] as [^a-z] to find the opposite of the character class
  def test_a_character_class_can_be_negated
    assert_equal "the number is ", "the number is 42"[/[^0-9]+/]
  end

  # \S (capitalized character class shortcuts are negatives
  def test_shortcut_character_classes_are_negated_with_capitals
    assert_equal "the number is ", "the number is 42"[/\D+/]
    assert_equal "space:", "space: \t\n"[/\S+/]
    # ... a programmer would most likely do
    assert_equal " = ", "variable_1 = 42"[/[^a-zA-Z0-9_]+/]
    assert_equal " = ", "variable_1 = 42"[/\W+/]
  end

  # ------------------------------------------------------------------

  # \A anchors to the start of the string 
  # (i.e. matches to the beginning of the string)

  def test_slash_a_anchors_to_the_start_of_the_string
    assert_equal "start", "start end"[/\Astart/]
    assert_equal(nil, "start end"[/\Aend/]);
  end

  # \z anchors (i.e. matches) to the end of the string
  def test_slash_z_anchors_to_the_end_of_the_string
	assert_equal "end", "start end"[/end\z/]
    assert_equal nil, "start end"[/start\z/]
  end

  # ^ matches to the start (i.e. beginning of lines)
  def test_caret_anchors_to_the_start_of_lines
    assert_equal "2", "num 42\n2 lines"[/^\d+/]
  end

  # $ matches to the end of lines
  def test_dollar_sign_anchors_to_the_end_of_lines
    assert_equal "42", "2 lines\nnum 42"[/\d+$/]
  end

  # \b anchors to the word boundaries
  def test_slash_b_anchors_to_a_word_boundary
    assert_equal "vines", "bovine vines"[/\bvine./]
  end

  # ------------------------------------------------------------------

  # parentheses can group their inner contents
  def test_parentheses_group_contents
    assert_equal "hahaha", "ahahaha"[/(ha)+/]
  end

  # ------------------------------------------------------------------

  # use regex to grab multiple pieces of content each enclosed by
  # parentheses and then grab them by indices starting at 1
  def test_parentheses_also_capture_matched_content_by_number
	# 0 indicates that both pieces should be used
    assert_equal "Gray, James", "Gray, James"[/(\w+), (\w+)/]
    assert_equal "Gray, James", "Gray, James"[/(\w+), (\w+)/, 0]
    assert_equal "Gray", "Gray, James"[/(\w+), (\w+)/, 1]
    assert_equal "James", "Gray, James"[/(\w+), (\w+)/, 2]
  end

  def test_variables_can_also_be_used_to_access_captures
    assert_equal "Gray, James", "Name:  Gray, James"[/(\w+), (\w+)/]
    assert_equal "Gray", $1
    assert_equal "James", $2
  end

  # ------------------------------------------------------------------

  # | is used as an OR expression
  def test_a_vertical_pipe_means_or
    grays = /(James|Dana|Summer) Gray/
    assert_equal "James Gray", "James Gray"[grays]
    assert_equal "Summer", "Summer Gray"[grays, 1] # because we only take the first piece matched
    assert_equal nil, "Jim Gray"[grays, 1]
  end

  # THINK ABOUT IT:
  #
  # Explain the difference between a character class ([...]) and alternation (|).
  # characters are limited to characters whereas an alternation can have multiple length strings

  # ------------------------------------------------------------------

  # scan = find all and return in an array
  def test_scan_is_like_find_all
    assert_equal ["one", "two", "three"], "one two-three".scan(/\w+/)
  end

  # sub is find and replace the first instance
  def test_sub_is_like_find_and_replace
									# REMEMBER: \w matches word characters (so you need the *)
    assert_equal "one t-three", "one two-three".sub(/(t\w*)/) { $1[0, 1] }
							# find the first word beginning with t and from that match take the first piece matched
							# and sub in that string's first character
	#
	# Globals set by regex:
	# $~ holds the match data
	# $& holds the whole text matched by the expression
	# $1, $2, etc. hold the data matched by the first, second, etc... capture groups
  end

  def test_gsub_is_like_find_and_replace_all
    assert_equal "one t-t", "one two-three".gsub(/(t\w*)/) { $1[0, 1] }
  end
end
