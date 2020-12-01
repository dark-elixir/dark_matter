defmodule DarkMatter.Structs do
  @moduledoc """
  Utils for working with structs.
  """
  @moduledoc since: "1.0.5"

  import DarkMatter.Guards,
    only: [
      is_module: 1,
      is_ecto_struct: 1,
      is_ecto_struct: 2
    ]

  @type t() :: struct()

  defdelegate struct?(struct), to: Kernel, as: :is_struct
  defdelegate struct?(struct, module), to: Kernel, as: :is_struct

  @doc """
  Define a guard clause for working with `Ecto` based `t:struct/0`.
  """
  @spec ecto_struct?(any()) :: boolean()
  def ecto_struct?(struct) do
    is_ecto_struct(struct)
  end

  @spec ecto_struct?(any(), module()) :: boolean()
  def ecto_struct?(struct, module) when is_module(module) do
    is_ecto_struct(struct, module)
  end

  @doc """
  Determine keys for a given `module` or raises `ArgumentError`.

  ## Examples

      iex> keys(IO.Stream)
      [:device, :line_or_bytes, :raw]

      iex> keys(%IO.Stream{})
      [:device, :line_or_bytes, :raw]

      iex> keys(%{})
      ** (FunctionClauseError) no function clause matching in DarkMatter.Structs.keys/1
  """
  @spec keys(module() | struct()) :: [atom()]
  def keys(module_or_struct) when is_module(module_or_struct) or is_struct(module_or_struct) do
    module_or_struct
    |> Map.from_struct()
    |> Map.keys()
    |> Enum.reject(&meta_key?/1)
    |> Enum.sort()
  end

  @doc """
  Determine if a given `key` is a meta map property.

  ## Examples

      iex> meta_key?(:__meta__)
      true

      iex> meta_key?(:__struct__)
      true

      iex> meta_key?(:non_meta)
      false
  """
  @spec meta_key?(atom()) :: boolean()
  def meta_key?(key) when is_atom(key) do
    string_key = Atom.to_string(key)
    String.starts_with?(string_key, "__") and String.ends_with?(string_key, "__")
  end
end
