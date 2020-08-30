defmodule DarkMatter.StringsTest do
  @moduledoc """
  Test for DarkMatter.Strings
  """

  use ExUnit.Case, async: true
  doctest DarkMatter.Strings, import: true

  alias DarkMatter.Strings

  describe ".blank?/1" do
    test "with nil" do
      ssn = nil
      assert Strings.blank?(ssn)
    end

    test "with empty string" do
      ssn = ""
      assert Strings.blank?(ssn)
    end

    test "with non-empty string" do
      ssn = "non-empty"
      refute Strings.blank?(ssn)
    end

    test "with whitespace-only string" do
      ssn = "        "
      refute Strings.blank?(ssn)
    end

    test "with non-empty string (trim: true)" do
      ssn = "non-empty"
      refute Strings.blank?(ssn, trim: true)
    end

    test "with whitespace-only string (trim: true)" do
      ssn = "   \n    \t  \r       "
      assert Strings.blank?(ssn, trim: true)
    end
  end

  describe ".normalize/1" do
    test "with valid :binary" do
      binary = "noeu0308l 👍🏿 👍🏾 👍🏽 👍🏼 👍🏻"

      assert Strings.normalize(binary) ==
               "noeu0308l \xF0\xF0 \xF0\xF0 \xF0\xF0 \xF0\xF0 \xF0\xF0"
    end
  end

  describe ".strip_non_digit/1" do
    test "with valid :binary" do
      binary = "12ab34cd absd &&124"
      assert Strings.strip_non_digit(binary) == "1234124"
    end
  end

  describe ".strip_non_words_characters/1" do
    test "with valid :binary" do
      binary = "My +-BinAry!#!:&*"
      assert Strings.strip_non_words_characters(binary) == "MyBinAry"
    end
  end

  describe ".strip_whitespace/1" do
    test "with valid :binary" do
      binary = "12ab34cd absd &&124"
      assert Strings.strip_whitespace(binary) == "12ab34cdabsd&&124"
    end
  end
end
