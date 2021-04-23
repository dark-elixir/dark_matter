defmodule DarkMatter.Decimals.Conversion do
  @moduledoc """
  Decimal conversion functions
  """
  @moduledoc since: "1.0.0"

  alias DarkMatter.Decimals.Arithmetic
  alias DarkMatter.Decimals.Comparison

  @type conversion_modes() :: :normal | :reduced
  @type stringable() :: String.t() | nil | Decimal.t()
  @type to_string_formatter() :: :usd

  @type round_option() :: {:round_up, pos_integer()}
  @type round_options() :: [round_option(), ...]

  @default_conversion_mode :reduced
  @conversion_modes [:normal, :reduced]
  @sanitize_symbols [",", "$", "_"]

  @doc """
  Generic to integer function
  """
  @spec to_number(DarkMatter.maybe_numeric()) :: DarkMatter.maybe_number()
  def to_number("0"), do: 0
  def to_number(nil), do: nil
  def to_number(%Decimal{} = decimal), do: Decimal.to_float(decimal)
  def to_number(float) when is_float(float), do: float
  def to_number(integer) when is_integer(integer), do: integer

  def to_number(binary) when is_binary(binary) do
    sanitized_binary = sanitize_binary(binary)

    case Integer.parse(sanitized_binary) do
      {integer, ""} when is_integer(integer) ->
        integer

      _any ->
        case Float.parse(sanitized_binary) do
          {float, ""} when is_float(float) -> float
          _any -> nil
        end
    end
  end

  @doc """
  Cast Decimal
  """
  @spec cast_decimal(any(), conversion_modes()) :: :error | nil | Decimal.t()
  def cast_decimal(decimal, mode \\ @default_conversion_mode)

  def cast_decimal(nil, mode) when mode in @conversion_modes do
    nil
  end

  def cast_decimal(%Decimal{} = decimal, :reduced) do
    Decimal.normalize(decimal)
  end

  def cast_decimal(%Decimal{} = decimal, :normal) do
    decimal
    |> Decimal.to_string(:normal)
    |> Comparison.decimal_parse()
  end

  def cast_decimal(float, mode) when is_float(float) and mode in @conversion_modes do
    float
    |> Decimal.from_float()
    |> cast_decimal(mode)
  end

  def cast_decimal(binary, mode) when is_binary(binary) and mode in @conversion_modes do
    binary
    |> sanitize_binary()
    |> Decimal.new()
    |> cast_decimal(mode)
  end

  def cast_decimal(integer, mode) when is_integer(integer) and mode in @conversion_modes do
    integer
    |> Decimal.new()
    |> cast_decimal(mode)
  end

  def cast_decimal(%{sign: sign, coef: coef, exp: exp}, mode) when mode in @conversion_modes do
    decimal = %Decimal{sign: sign, coef: coef, exp: exp}
    cast_decimal(decimal, mode)
  end

  def cast_decimal(_item, mode) when mode in @conversion_modes do
    :error
  end

  @doc """
  Cast Decimal
  """
  @spec cast_decimal!(any(), conversion_modes()) :: Decimal.t()
  def cast_decimal!(numeric, mode \\ @default_conversion_mode) when mode in @conversion_modes do
    case cast_decimal_ok(numeric, mode) do
      {:ok, %Decimal{} = decimal} -> decimal
      _any -> raise ArgumentError, message: "invalid argument #{inspect(numeric)}"
    end
  end

  @doc """
  Cast Decimal ok
  """
  @spec cast_decimal_ok(any(), conversion_modes()) :: {:ok, Decimal.t()} | :error
  def cast_decimal_ok(numeric, mode \\ @default_conversion_mode) do
    case cast_decimal(numeric, mode) do
      %Decimal{} = decimal -> {:ok, decimal}
      _any -> :error
    end
  end

  @doc """
  ((n + (factor/2)) / factor) * factor
  """
  @spec decimal_round_ok(any(), round_options()) :: {:ok, Decimal.t()} | :error
  def decimal_round_ok(amount, round_up: factor) when is_integer(factor) and factor > 0 do
    if rounded?(amount, round_up: factor) do
      cast_decimal_ok(amount)
    else
      with {:ok, decimal} <- cast_decimal_ok(amount) do
        rounded_amount =
          decimal
          |> Decimal.add(Decimal.div(factor, 2))
          |> Decimal.div(factor)
          |> Decimal.round()
          |> Arithmetic.decimal_mult(factor)

        {:ok, rounded_amount}
      end
    end
  end

  @doc """
  Determine if a number is rounded.
  """
  @spec rounded?(any(), round_options()) :: boolean()
  def rounded?(amount, round_up: factor) when is_integer(factor) and factor > 0 do
    amount
    |> cast_decimal()
    |> Decimal.rem(cast_decimal(factor))
    |> Comparison.decimal_equal?(0)
  end

  @spec sanitize_binary(String.t()) :: String.t()
  defp sanitize_binary(binary) when is_binary(binary) do
    for substring <- @sanitize_symbols, reduce: binary do
      binary -> String.replace(binary, substring, "")
    end
  end

  @doc """
  Transform a `t:stringable.t/0` into a normalized string.

  Raises `ArgumentError`  if a given binary isn't a valid `Decimal`.
  """
  @spec to_string(stringable()) :: String.t() | nil
  def to_string(nil) do
    nil
  end

  def to_string(binary) when is_binary(binary) do
    binary
    |> cast_decimal!()
    |> __MODULE__.to_string()
  end

  def to_string(%Decimal{} = decimal) do
    Decimal.to_string(decimal, :normal)
  end

  @doc """
  Transform a `t:stringable.t/0` into a normalized formatted string.

  Raises `ArgumentError`  if a given binary isn't a valid `Decimal`.
  """
  @spec to_string(stringable(), to_string_formatter()) :: String.t() | nil
  def to_string(stringable, :usd) do
    case __MODULE__.to_string(stringable) do
      binary when is_binary(binary) -> "$#{binary}"
      any -> any
    end
  end
end
