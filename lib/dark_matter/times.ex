defmodule DarkMatter.Times do
  @moduledoc """
  Timetime Utils
  """
  @moduledoc since: "1.0.0"

  @type stringable() :: nil | String.t() | Time.t()

  @doc """
  Casts a `t:stringable/0` into a `Time`

  Raises `ArgumentError` if a given `Time` isn't valid.
  """
  @spec cast_time(stringable()) :: nil | Time.t()
  def cast_time(%Time{} = time), do: time
  def cast_time(binary) when is_binary(binary), do: from_iso8601!(binary)
  def cast_time(nil), do: nil

  @doc """
  Transform a `Time` into a string.

  Raises `ArgumentError` if a given `Time` isn't valid.
  """
  @spec from_iso8601!(String.t()) :: Time.t()
  def from_iso8601!(binary) when is_binary(binary) do
    Time.from_iso8601!(binary)
  end

  @doc """
  Transform a `t:stringable/0` into a string.

  Raises `ArgumentError`  if a given binary isn't a valid `Time`.
  """
  @spec to_string(stringable()) :: nil | String.t()
  def to_string(%Time{} = time) do
    Time.to_iso8601(time)
  end

  def to_string(time) when is_binary(time) do
    time
    |> from_iso8601!()
    |> __MODULE__.to_string()
  end

  def to_string(nil) do
    nil
  end
end
