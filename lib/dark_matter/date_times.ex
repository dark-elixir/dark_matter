defmodule DarkMatter.DateTimes do
  @moduledoc """
  Datetime Utils
  """
  @moduledoc since: "1.0.0"

  @type stringable() :: nil | String.t() | DateTime.t() | NaiveDateTime.t()

  @doc """
  Returns the current utc time
  """
  @spec now! :: DateTime.t()
  def now! do
    DateTime.now!("Etc/UTC")
  end

  @doc """
  Casts a `t:stringable/0` into a `DateTime`

  Raises `ArgumentError` if a given `DateTime` isn't valid.
  """
  @spec cast_datetime(stringable()) :: nil | DateTime.t()
  def cast_datetime(%DateTime{} = datetime), do: datetime
  def cast_datetime(%NaiveDateTime{} = datetime), do: DateTime.from_naive!(datetime, "Etc/UTC")
  def cast_datetime(binary) when is_binary(binary), do: from_iso8601!(binary)
  def cast_datetime(nil), do: nil

  @doc """
  Transform a `DateTime` into a string.

  Raises `ArgumentError` if a given `DateTime` isn't valid.
  """
  @spec from_iso8601!(String.t()) :: DateTime.t()
  def from_iso8601!(binary) when is_binary(binary) do
    case DateTime.from_iso8601(binary) do
      {:ok, %DateTime{} = datetime, 0} ->
        datetime

      _ ->
        raise ArgumentError,
          message: "cannot parse #{inspect(binary)} as datetime, reason: :invalid_format"
    end
  end

  @doc """
  Transform a `t:stringable/0` into a string.

  Raises `ArgumentError`  if a given binary isn't a valid `DateTime`.
  """
  @spec to_string(stringable()) :: nil | String.t()
  def to_string(%DateTime{} = datetime) do
    DateTime.to_iso8601(datetime)
  end

  def to_string(%NaiveDateTime{} = naive_datetime) do
    NaiveDateTime.to_iso8601(naive_datetime)
  end

  def to_string(datetime) when is_binary(datetime) do
    datetime |> from_iso8601!() |> __MODULE__.to_string()
  end

  def to_string(nil) do
    nil
  end
end
