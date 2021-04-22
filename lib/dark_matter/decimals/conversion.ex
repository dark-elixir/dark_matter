defmodule DarkMatter.Decimals.Conversion do
  @moduledoc """
  Decimal conversion functions
  """
  @moduledoc since: "1.0.0"

  alias DarkMatter.Decimals.Arithmetic

  @type stringable() :: nil | String.t() | Decimal.t()

  @default_mode :reduced

  @doc """
  Generic to integer function
  """
  # def to_number("0"), do: 0
  # def to_number(0.0), do: 0
  def to_number(nil), do: nil
  def to_number(%Decimal{} = decimal), do: Decimal.to_float(decimal)
  def to_number(float) when is_float(float), do: float
  def to_number(integer) when is_integer(integer), do: integer

  def to_number(binary) when is_binary(binary) do
    sanitized_binary = sanitize_binary(binary)

    case Integer.parse(sanitized_binary) do
      {integer, ""} when is_integer(integer) ->
        integer

      _ ->
        case Float.parse(sanitized_binary) do
          {float, ""} when is_float(float) -> float
          _ -> nil
        end
    end
  end

  @doc """
  Cast Decimal
  """
  def cast_decimal(decimal, mode \\ @default_mode)

  def cast_decimal(nil, _) do
    nil
  end

  def cast_decimal(%Decimal{} = decimal, :reduced) do
    decimal |> Decimal.normalize()
  end

  def cast_decimal(%Decimal{} = decimal, :normal) do
    {normal_decimal, _remainder} = decimal |> Decimal.to_string(:normal) |> Decimal.parse()
    normal_decimal
  end

  def cast_decimal(float, mode) when is_float(float) do
    float |> Decimal.from_float() |> cast_decimal(mode)
  end

  def cast_decimal(binary, mode) when is_binary(binary) do
    binary
    |> sanitize_binary()
    |> Decimal.new()
    |> cast_decimal(mode)
  end

  def cast_decimal(integer, mode) when is_integer(integer) do
    integer |> Decimal.new() |> cast_decimal(mode)
  end

  def cast_decimal(%{sign: sign, coef: coef, exp: exp}, mode) do
    %Decimal{sign: sign, coef: coef, exp: exp} |> cast_decimal(mode)
  end

  def cast_decimal(_item, _mode) do
    :error
  end

  @doc """
  Cast Decimal
  """
  def cast_decimal!(numeric, mode \\ @default_mode) do
    case cast_decimal_ok(numeric, mode) do
      {:ok, %Decimal{} = decimal} -> decimal
      _ -> raise ArgumentError, message: "invalid argument #{inspect(numeric)}"
    end
  end

  @doc """
  Cast Decimal ok
  """
  def cast_decimal_ok(numeric, mode \\ @default_mode) do
    case cast_decimal(numeric, mode) do
      %Decimal{} = decimal -> {:ok, decimal}
      _ -> :error
    end
  end

  @doc """
  Compare Decimal
  """
  def decimal_cmp(x, y) do
    Decimal.compare(cast_decimal(x), cast_decimal(y))
  end

  @doc """
  Determines if two decimals are equivalent.
  """
  def decimal_equal?(x, y) do
    Decimal.compare(cast_decimal(x), cast_decimal(y)) == :eq
  end

  @doc """
  ((n + (factor/2)) / factor) * factor
  """
  def decimal_round_ok(amount, round_up: factor) when is_integer(factor) and factor > 0 do
    if rounded?(amount, round_up: factor) do
      {:ok, cast_decimal(amount)}
    else
      rounded_amount =
        amount
        |> cast_decimal()
        |> Decimal.add(Decimal.div(factor, 2))
        |> Decimal.div(factor)
        |> Decimal.round()
        |> Arithmetic.decimal_mult(factor)

      {:ok, rounded_amount}
    end
  end

  def rounded?(amount, round_up: factor) when is_integer(factor) and factor > 0 do
    rem =
      amount
      |> cast_decimal()
      |> Decimal.rem(cast_decimal(factor))

    Decimal.compare(rem, Decimal.new(0)) == :eq
  end

  defp sanitize_binary(binary) when is_binary(binary) do
    binary
    |> String.replace(",", "")
    |> String.replace("$", "")
    |> String.replace("_", "")
  end

  @doc """
  Transform a `t:stringable.t/0` into a normalized exponent string.

  Raises `ArgumentError`  if a given binary isn't a valid `Decimal`.
  """
  @spec to_string(stringable()) :: nil | String.t()
  def to_string(%Decimal{} = decimal) do
    Decimal.to_string(decimal, :normal)
  end

  def to_string(decimal) when is_binary(decimal) do
    decimal |> cast_decimal!() |> __MODULE__.to_string()
  end

  def to_string(nil) do
    nil
  end

  def to_string(decimal, :usd) do
    case __MODULE__.to_string(decimal) do
      binary when is_binary(binary) -> "$#{binary}"
      any -> any
    end
  end
end
