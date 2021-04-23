defmodule DarkMatter.Lists do
  @moduledoc """
  Utils for working with lists or improper lists
  """
  @moduledoc since: "1.0.0"

  @type atom_or_improper_tree_list() ::
          atom
          | maybe_improper_list
          | {atom, atom | maybe_improper_list | {atom, atom | maybe_improper_list | {any, any}}}

  @doc """
  Flattens common tree shaped keyword lists into a single list

  ## Examples

      iex> flatten_atom_or_improper_tree_list([])
      []

      iex> flatten_atom_or_improper_tree_list(:atom)
      [:atom]

      iex> flatten_atom_or_improper_tree_list([:atom_list])
      [:atom_list]

      iex> flatten_atom_or_improper_tree_list({:tuple, :atom})
      [:tuple, :atom]

      iex> flatten_atom_or_improper_tree_list([tuple: :list])
      [:tuple, :list]

      iex> flatten_atom_or_improper_tree_list([tuple: [nested: :atom]])
      [:tuple, :nested, :atom]

      iex> flatten_atom_or_improper_tree_list([tuple: [nested: [:list, :atom]]])
      [:tuple, :nested, :list, :atom]

      iex> flatten_atom_or_improper_tree_list([:atom, tuple: [nested: [:nested2, nested3: [:nested4]]]])
      [:atom, :tuple, :nested, :nested2, :nested3, :nested4]
  """
  @spec flatten_atom_or_improper_tree_list(atom_or_improper_tree_list()) :: [atom()]
  def flatten_atom_or_improper_tree_list(val) do
    do_flatten_atom_or_improper_tree_list([], val)
  end

  defp do_flatten_atom_or_improper_tree_list(acc, atom) when is_list(acc) and is_atom(atom) do
    [atom | acc]
  end

  defp do_flatten_atom_or_improper_tree_list(acc, {atom, val})
       when is_list(acc) and is_atom(atom) do
    [atom | do_flatten_atom_or_improper_tree_list([], val)] ++ acc
  end

  defp do_flatten_atom_or_improper_tree_list(acc, list) when is_list(acc) and is_list(list) do
    acc ++ Enum.flat_map(list, &do_flatten_atom_or_improper_tree_list([], &1))
  end

  @doc """
  Split list into uniques
  """
  @spec split_uniq(Enumerable.t()) :: {Enumerable.t(), Enumerable.t()}
  def split_uniq(enumerable) do
    split_uniq_by(enumerable, fn x -> x end)
  end

  @doc """
  Split list into uniques by `fun`
  """
  @spec split_uniq_by(Enumerable.t(), (any() -> any())) :: {Enumerable.t(), Enumerable.t()}
  def split_uniq_by(enumerable, fun) when is_list(enumerable) do
    split_uniq_list(enumerable, %{}, fun)
  end

  defp split_uniq_list([head | tail], set, fun) do
    value = fun.(head)

    case set do
      %{^value => true} ->
        {uniq, dupl} = split_uniq_list(tail, set, fun)
        {uniq, [head | dupl]}

      %{} ->
        {uniq, dupl} = split_uniq_list(tail, Map.put(set, value, true), fun)
        {[head | uniq], dupl}
    end
  end

  defp split_uniq_list([], _set, _fun) do
    {[], []}
  end
end
