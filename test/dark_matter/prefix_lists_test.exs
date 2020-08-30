defmodule DarkMatter.PrefixListsTest do
  @moduledoc """
  Test for `DarkMatter.PrefixLists`.
  """

  use ExUnit.Case, async: true
  doctest DarkMatter.PrefixLists, import: true

  alias DarkMatter.PrefixLists

  @cases [
    {:single_atom, [:single_atom]},
    {[:single_atom], [:single_atom]},
    {[prefix: :item], [:prefix_item]},
    {[prefix: [:item1, :item2]], [:prefix_item1, :prefix_item2]}
  ]

  describe ".expand/1" do
    for {given, expected} <- @cases do
      test "given #{inspect(given)} expect #{inspect(expected)}" do
        assert PrefixLists.expand(unquote(given)) == unquote(expected)
      end
    end
  end
end
