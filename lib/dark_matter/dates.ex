defmodule DarkMatter.Dates do
  @moduledoc """
  Datetime Utils
  """
  @moduledoc since: "1.0.0"

  @type stringable() :: nil | String.t() | Date.t()

  @doc """
  Casts a `t:stringable/0` into a `Date`

  Raises `ArgumentError` if a given `Date` isn't valid.
  """
  @spec cast_date(stringable()) :: nil | Date.t()
  def cast_date(%Date{} = date), do: date
  def cast_date(binary) when is_binary(binary), do: from_iso8601!(binary)
  def cast_date(nil), do: nil

  @doc """
  Transform a `Date` into a string.

  Raises `ArgumentError` if a given `Date` isn't valid.
  """
  @spec from_iso8601!(String.t()) :: Date.t()
  def from_iso8601!(binary) when is_binary(binary) do
    Date.from_iso8601!(binary)
  end

  @doc """
  Transform a `t:stringable/0` into a string.

  Raises `ArgumentError`  if a given binary isn't a valid `Date`.
  """
  @spec to_string(stringable()) :: nil | String.t()
  def to_string(%Date{} = date) do
    Date.to_iso8601(date)
  end

  def to_string(date) when is_binary(date) do
    date |> from_iso8601!() |> __MODULE__.to_string()
  end

  def to_string(nil) do
    nil
  end
end
