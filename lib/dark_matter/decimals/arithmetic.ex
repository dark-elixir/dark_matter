defmodule DarkMatter.Decimals.Arithmetic do
  @moduledoc """
  Decimal arithmetic functions
  """
  @moduledoc since: "1.0.0"

  alias DarkMatter.Decimals.Conversion

  @doc """
  Add Decimal
  """
  def decimal_add(x0, x1) do
    x0
    |> Conversion.cast_decimal()
    |> Decimal.add(Conversion.cast_decimal(x1))
    |> Decimal.reduce()
  end

  @doc """
  Avg Decimal
  """
  def decimal_avg(decimals, default \\ 0)
  def decimal_avg([], default), do: Conversion.cast_decimal(default)

  def decimal_avg(decimals, default) when is_list(decimals) do
    decimals
    |> decimal_sum(default)
    |> decimal_div(length(decimals), default)

    # |> Decimal.reduce()
  end

  @doc """
  Div Decimal
  """
  def decimal_div(dividend, divisor, default \\ 0)
  def decimal_div(nil, _divisor, default), do: Conversion.cast_decimal(default)
  def decimal_div(_dividend, nil, default), do: Conversion.cast_decimal(default)

  def decimal_div(dividend, divisor, default) do
    if Decimal.cmp(Conversion.cast_decimal!(dividend), 0) == :eq do
      Conversion.cast_decimal(default)
    else
      dividend
      |> Conversion.cast_decimal!()
      |> Decimal.div(Conversion.cast_decimal!(divisor))
      |> Decimal.reduce()
    end
  end

  @doc """
  Multiply Decimal
  """
  def decimal_mult(left, right) do
    left
    |> Conversion.cast_decimal!()
    |> Decimal.mult(Conversion.cast_decimal!(right))
    |> Decimal.reduce()
  end

  @doc """
  Sub Decimal
  """
  def decimal_sub(x0, x1) do
    x0
    |> Conversion.cast_decimal()
    |> Decimal.sub(Conversion.cast_decimal(x1))
    |> Decimal.reduce()
  end

  @doc """
  Sum Decimal
  """
  def decimal_sum(decimals, default \\ 0)
  def decimal_sum([], default), do: Conversion.cast_decimal(default)

  def decimal_sum(decimals, _default) when is_list(decimals) do
    decimals
    |> Enum.map(&Conversion.cast_decimal!/1)
    |> Enum.reduce(Conversion.cast_decimal(0), &Decimal.add/2)
    |> Decimal.reduce()
  end

  @doc """
  Percent Decimal
  """
  def from_percentage(amount) do
    amount
    |> decimal_div(100)
  end

  @doc """
  Percent Decimal
  """
  def to_percentage(amount) do
    amount
    |> decimal_mult(100)
  end

  @doc """
  Percent Decimal
  """
  def decimal_percent(allocation, total) do
    allocation
    |> decimal_mult(100)
    |> decimal_div(total)
  end
end
