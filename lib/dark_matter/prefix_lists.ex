defmodule DarkMatter.PrefixLists do
  @moduledoc """
  Utils for working with prefix lists
  """
  @moduledoc since: "1.0.0"

  @type atom_or_improper_prefix_list() ::
          atom()
          | {atom(), atom_or_improper_prefix_list()}
          | [atom_or_improper_prefix_list()]

  @type expanded_prefix_list() :: [atom()]

  @doc """
  Expanding prefix lists into a flattened concat representation.

  ## Examples

  iex> expand([])
  []

  iex> expand(:atom)
  [:atom]

  iex> expand(keyword: :list)
  [:keyword_list]

  iex> expand(nested: [[[[:list_of_lists]]]])
  [:nested_list_of_lists]

  iex> expand(a: [very: [nested: :list]])
  [:a_very_nested_list]

  iex> expand(two: [very: [nested: [:compound_atom, and: [nested: :list]]]])
  [:two_very_nested_compound_atom, :two_very_nested_and_nested_list]

  iex> expand(three: [very: [nested: [:compound_atom, [:list_atom], and: [nested: :list]]]])
  [
    :three_very_nested_compound_atom,
    :three_very_nested_list_atom,
    :three_very_nested_and_nested_list
  ]
  """
  @spec expand(atom_or_improper_prefix_list()) :: expanded_prefix_list()
  def expand(key) when is_atom(key) do
    [key]
  end

  def expand(list) when is_list(list) do
    Enum.flat_map(list, &expand/1)
  end

  def expand({prefix, key}) when is_atom(prefix) and is_atom(key) do
    [:"#{prefix}_#{key}"]
  end

  def expand({prefix, list}) when is_atom(prefix) and is_list(list) do
    for key_or_keys <- list,
        suffix <- expand(key_or_keys),
        reduce: [] do
      acc -> acc ++ [:"#{prefix}_#{suffix}"]
    end
  end
end
