defmodule DarkMatter.Enums do
  @moduledoc """
  General utils for working with the enums.
  """
  @moduledoc since: "1.0.0"

  # credo:disable-for-this-file

  @doc """
  Handles casting into a string keyed json format
  """
  @spec stringify(any(), opts :: Keyword.t()) :: %{required(binary()) => any()}
  def stringify(data, opts \\ []) do
    jsonify(data, [values: true, yield: :all] |> Keyword.merge(opts) |> Keyword.merge(keys: true))
  end

  @doc """
  Handles casting into a json safe format
  """
  @spec jsonify(any(), opts :: Keyword.t()) :: map()
  def jsonify(data, opts \\ [keys: false, values: false])

  # Override implementations
  #
  def jsonify(%Date{} = date, _opts), do: Date.to_iso8601(date)
  def jsonify(%DateTime{} = datetime, _opts), do: DateTime.to_iso8601(datetime)
  def jsonify(%Decimal{} = decimal, _opts), do: Decimal.to_string(decimal, :normal)
  def jsonify(%{__meta__: _} = ecto, opts), do: ecto |> Map.drop([:__meta__]) |> jsonify(opts)
  def jsonify(boolean, _opts) when is_boolean(boolean), do: boolean
  def jsonify(integer, _opts) when is_integer(integer), do: integer
  def jsonify(float, _opts) when is_float(float), do: float

  # Default JSON handling
  #
  def jsonify(nil, _opts), do: nil
  def jsonify(tuple, opts) when is_tuple(tuple), do: tuple |> Tuple.to_list() |> jsonify(opts)
  def jsonify([{_, _} | _] = data, opts), do: data |> Map.new() |> jsonify(opts)
  def jsonify(data, opts) when is_list(data), do: Enum.map(data, &jsonify(&1, opts))

  def jsonify(data, opts) when is_atom(data) do
    if(opts[:values], do: to_string(data), else: data)
  end

  def jsonify(data, opts) when is_map(data) or is_list(data) do
    Iteraptor.map(data, &do_jsonify(&1, opts), yield: Keyword.get(opts, :yield, :all))
  end

  def jsonify(data, _opts), do: data

  defp do_jsonify({k, [{_, _} | _] = kw}, opts) when is_list(k) do
    {k |> List.last() |> do_stringify_key(opts), jsonify(kw, opts)}
  end

  defp do_jsonify({k, v}, opts) when is_list(k) do
    {k |> List.last() |> do_stringify_key(opts), jsonify(v, opts)}
  end

  defp do_stringify_key(k, opts), do: if(opts[:keys], do: to_string(k), else: k)

  @doc """
  Maintains keys while merging structs
  """
  @spec struct_merge(struct() | map(), struct() | map()) :: struct() | map()
  def struct_merge(struct, params) do
    Map.merge(struct, Map.take(params, Map.keys(struct)))
  end
end
