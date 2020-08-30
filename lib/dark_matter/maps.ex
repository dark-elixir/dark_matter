defmodule DarkMatter.Maps do
  @moduledoc """
  Utils for handling maps
  """
  @moduledoc since: "1.0.0"

  @type access_key() :: atom() | String.t()
  @type access_key_or_keys() :: access_key() | [access_key(), ...]

  @compact_defaults %{allow_nil: false, deep: false}

  @doc """
  Returns a map with nil values omitted
  """
  @spec compact(map() | struct(), opts :: Keyword.t() | map()) :: map()
  def compact(map_or_struct, opts \\ @compact_defaults)

  def compact(map_or_struct, opts) when is_list(opts) do
    compact(map_or_struct, Enum.into(opts, @compact_defaults))
  end

  def compact(%module{} = struct, _opts) when module in [Date, DateTime, Decimal, Money] do
    struct
  end

  def compact(%module{}, _opts) when module in [Ecto.Association.NotLoaded] do
    nil
  end

  def compact(%{__struct__: _} = struct, opts) do
    struct
    |> Map.from_struct()
    |> Map.delete(:__meta__)
    |> compact(opts)
  end

  def compact(map, %{allow_nil: false, deep: true} = opts) when is_map(map) do
    for {k, v} <- map, v != nil, into: %{}, do: {k, compact(v, opts)}
  end

  def compact(map, %{allow_nil: true, deep: true} = opts) when is_map(map) do
    for {k, v} <- map, into: %{}, do: {k, compact(v, opts)}
  end

  def compact(map, %{allow_nil: false, deep: false}) when is_map(map) do
    for {k, v} <- map, v != nil, into: %{}, do: {k, v}
  end

  def compact(map, %{allow_nil: true, deep: false}) when is_map(map) do
    for {k, v} <- map, into: %{}, do: {k, v}
  end

  def compact(any, _opts) do
    any
  end

  @doc """
  Safe version of `Kernel.get_in/2`
  """
  @spec access_in(map(), access_key_or_keys(), any()) :: any()
  def access_in(map, key_or_keys, default \\ nil)

  def access_in(map, key, default) when is_map(map) and (is_atom(key) or is_binary(key)) do
    access_in(map, List.wrap(key), default)
  end

  def access_in(map, keys, default) when is_map(map) and is_list(keys) do
    access_keys =
      Enum.map(keys, fn
        key when is_atom(key) -> Access.key(key)
        key when is_binary(key) -> Access.key(key)
      end)

    get_in(map, access_keys) || default
  end

  @doc """
  Returns a sorted list of atom keys found in `results`.
  """
  @spec sorted_keys(map()) :: [atom() | String.t(), ...]
  def sorted_keys(results) when is_map(results) do
    results
    |> Map.keys()
    |> Enum.sort()
  end
end
