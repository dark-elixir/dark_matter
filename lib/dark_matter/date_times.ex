defmodule DarkMatter.DateTimes do
  @moduledoc """
  Datetime Utils
  """
  @moduledoc since: "1.0.0"

  @type stringable() :: nil | (unix :: integer()) | String.t() | DateTime.t() | NaiveDateTime.t()
  # @type unix_opt() :: {:unit, System.time_unit()} | {:epoch, DateTime.t()}

  # @unit :nanosecond
  @timezone "Etc/UTC"
  # @unix_epoch ~U[1970-01-01 00:00:00.000000Z]
  # @cf_absolute_epoch ~U[2001-01-01 00:00:00.000000Z]

  @doc """
  Returns the current utc time
  """
  @spec now! :: DateTime.t()
  def now! do
    DateTime.now!(@timezone)
  end

  @doc """
  Casts a `t:stringable/0` into a `t:DateTime.t/0`

  Raises `ArgumentError` if a given `t:DateTime.t/0` isn't valid.
  """
  @spec cast_datetime(stringable()) :: nil | DateTime.t()
  def cast_datetime(%DateTime{} = datetime), do: datetime
  def cast_datetime(%NaiveDateTime{} = datetime), do: DateTime.from_naive!(datetime, @timezone)
  def cast_datetime(binary) when is_binary(binary), do: from_iso8601!(binary)
  def cast_datetime(nil), do: nil

  @doc """
  Transform a `t:DateTime.t/0` into a string.

  Raises `ArgumentError` if a given `t:DateTime.t/0` isn't valid.
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

  # @doc """
  # Transform a unix epoc integer into a `t:DateTime.t/0`.
  # """
  # @spec from_unix!(integer()) :: nil | DateTime.t()
  # def from_unix!(integer) when is_integer(integer) do
  #   DateTime.from_unix!(integer, @unit)
  # end

  # @doc """
  # Transform a `t:DateTime.t/0` into a iOS `CFAbsoluteTime` unix epoc integer.

  # Raises `ArgumentError` if a given `t:DateTime.t/0` isn't valid.
  # """
  # @spec cast_unix(stringable(), [unix_opt()]) :: {:ok, pos_integer()} | :error
  # def cast_unix(value, opts \\ [])

  # def cast_unix(nil, _) do
  #   {:ok, nil}
  # end

  # def cast_unix(integer, _) when is_integer(integer) and integer > 0 do
  #   {:ok, integer}
  # end

  # def cast_unix(value, opts) do
  #   unit = Keyword.get(opts, :unit, @unit)
  #   epoch = Keyword.get(opts, :epoc, @unix_epoch)

  #   case cast_datetime(value) do
  #     %DateTime{} = datetime ->
  #       unix = DateTime.to_unix(datetime, unit) + DateTime.to_unix(epoch, unit)
  #       {:ok, unix}

  #     _ ->
  #       :error
  #   end
  # end

  # @doc """
  # Transform a `t:DateTime.t/0` into a iOS `CFAbsoluteTime` unix epoc integer.

  # Raises `ArgumentError` if a given `t:DateTime.t/0` isn't valid.
  # """
  # @spec load_unix(stringable(), [unix_opt()]) :: {:ok, pos_integer()} | :error
  # def load_unix(value, opts \\ [])

  # def load_unix(%DateTime{} = datetime, opts) do
  #   unit = Keyword.get(opts, :unit, @unit)
  #   epoch = Keyword.get(opts, :epoc, @unix_epoch)

  #   unix = DateTime.to_unix(datetime, unit) + DateTime.to_unix(epoch, unit)
  #   {:ok, unix}
  # end

  # def load_unix(%NaiveDateTime{} = datetime, opts),
  #   do: datetime |> cast_datetime() |> load_unix(opts)

  # def load_unix(binary, opts) when is_binary(binary),
  #   do: binary |> cast_datetime() |> load_unix(opts)

  # def load_unix(integer, opts) when is_integer(integer) and integer > 0 do
  #   unit = Keyword.get(opts, :unit, @unit)
  #   epoch = Keyword.get(opts, :epoc, @unix_epoch)
  #   epoch_time = DateTime.to_unix(epoch, unit)

  #   case DateTime.from_unix(integer - epoch_time, unit) do
  #     {:ok, %DateTime{} = datetime} -> {:ok, datetime}
  #     _ -> :error
  #   end
  # end

  # def load_unix(nil, _), do: {:ok, nil}
  # def load_unix(_, _), do: :error

  # @doc """
  # Transform a `t:DateTime.t/0` into a iOS `CFAbsoluteTime` unix epoc integer.

  # Raises `ArgumentError` if a given `t:DateTime.t/0` isn't valid.
  # """
  # @spec cast_cf_absolute_time(any) :: {:ok, pos_integer()} | :error
  # def cast_cf_absolute_time(value) do
  #   cast_unix(value, unit: @unit, epoch: @cf_absolute_epoch)
  # end

  # def cast_cf_absolute_time(%NaiveDateTime{} = datetime) do
  #   datetime |> cast_datetime() |> cast_cf_absolute_time()
  # end

  # def cast_cf_absolute_time(binary) when is_binary(binary) do
  #   binary |> cast_datetime() |> cast_cf_absolute_time()
  # end

  # def cast_cf_absolute_time(integer) when is_integer(integer) when integer > 0, do: {:ok, integer}
  # def cast_cf_absolute_time(nil), do: {:ok, nil}
  # def cast_cf_absolute_time(_), do: :error

  # @doc """
  # Transform a iOS `CFAbsoluteTime` unix epoc integer into a `t:DateTime.t/0`.
  # """
  # @spec load_cf_absolute_time(integer) :: {:ok, DateTime.t()} | :error
  # def load_cf_absolute_time(integer) when is_integer(integer) do
  #   case DateTime.from_unix(integer - @cf_absolute_epoch, @unit) do
  #     {:ok, %DateTime{} = datetime} -> {:ok, datetime}
  #     _ -> :error
  #   end
  # end

  @doc """
  Transform a `t:stringable/0` into a string.

  Raises `ArgumentError`  if a given binary isn't a valid `t:DateTime.t/0`.
  """
  @spec to_string(stringable()) :: nil | String.t()
  def to_string(%DateTime{} = datetime) do
    DateTime.to_iso8601(datetime)
  end

  def to_string(%NaiveDateTime{} = naive_datetime) do
    NaiveDateTime.to_iso8601(naive_datetime)
  end

  def to_string(binary) when is_binary(binary) do
    binary |> from_iso8601!() |> __MODULE__.to_string()
  end

  # def to_string(integer) when is_integer(integer) do
  #   integer |> cast_unix() |> __MODULE__.to_string()
  # end

  def to_string(nil) do
    nil
  end
end
