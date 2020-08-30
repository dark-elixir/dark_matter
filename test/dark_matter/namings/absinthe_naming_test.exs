defmodule DarkMatter.Namings.AbsintheNamingTest do
  @moduledoc """
  Test for `DarkMatter.Namings.AbsintheNaming`
  """

  use ExUnit.Case, async: true
  alias DarkMatter.Namings.AbsintheNaming

  doctest AbsintheNaming, import: true

  @snake "foo_bar"
  @preunderscored_snake "__foo_bar"

  describe "camelize with :lower" do
    test "handles normal snake-cased values" do
      assert "fooBar" == AbsintheNaming.camelize(@snake, lower: true)
    end

    test "handles snake-cased values starting with double underscores" do
      assert "__fooBar" == AbsintheNaming.camelize(@preunderscored_snake, lower: true)
    end
  end

  describe "camelize without :lower" do
    test "handles normal snake-cased values" do
      assert "FooBar" == AbsintheNaming.camelize(@snake)
    end

    test "handles snake-cased values starting with double underscores" do
      assert "__FooBar" == AbsintheNaming.camelize(@preunderscored_snake)
    end
  end
end
