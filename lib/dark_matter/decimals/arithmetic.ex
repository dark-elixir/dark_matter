defmodule DarkMatter.Decimals.Arithmetic do
  @moduledoc """
  Decimal arithmetic functions
  """
  @moduledoc since: "1.0.0"

  import DarkMatter.Guards

  alias DarkMatter.Decimals.Comparison
  alias DarkMatter.Decimals.Conversion

  @doc """
  Add Decimal
  """
  @spec decimal_add(DarkMatter.numeric(), DarkMatter.strict_numeric()) :: Decimal.t()
  def decimal_add(x0, x1) do
    x0
    |> Conversion.cast_decimal()
    |> Decimal.add(Conversion.cast_decimal(x1))
    |> Decimal.normalize()
  end

  @doc """
  Avg Decimal
  """
  @spec decimal_avg([DarkMatter.numeric()], DarkMatter.strict_numeric()) :: Decimal.t()
  def decimal_avg(decimals, default \\ 0)

  def decimal_avg([], default) when is_strict_numeric(default) do
    Conversion.cast_decimal(default)
  end

  def decimal_avg(decimals, default) when is_list(decimals) and is_strict_numeric(default) do
    decimals
    |> decimal_sum(default)
    |> decimal_div(length(decimals), default)

    # |> Decimal.normalize()
  end

  @doc """
  Div Decimal
  """
  @spec decimal_div(DarkMatter.numeric(), DarkMatter.numeric(), DarkMatter.strict_numeric()) ::
          Decimal.t()
  def decimal_div(dividend, divisor, default \\ 0)

  def decimal_div(nil, _divisor, default) when is_strict_numeric(default) do
    Conversion.cast_decimal(default)
  end

  def decimal_div(_dividend, nil, default) when is_strict_numeric(default) do
    Conversion.cast_decimal(default)
  end

  def decimal_div(dividend, divisor, default) when is_strict_numeric(default) do
    if Comparison.decimal_equal?(dividend, 0) do
      Conversion.cast_decimal(default)
    else
      dividend
      |> Conversion.cast_decimal!()
      |> Decimal.div(Conversion.cast_decimal!(divisor))
      |> Decimal.normalize()
    end
  end

  @doc """
  Multiply Decimal
  """
  @spec decimal_mult(DarkMatter.numeric(), DarkMatter.numeric()) :: Decimal.t()
  def decimal_mult(left, right) do
    left
    |> Conversion.cast_decimal!()
    |> Decimal.mult(Conversion.cast_decimal!(right))
    |> Decimal.normalize()
  end

  @doc """
  Sub Decimal
  """
  @spec decimal_sub(DarkMatter.numeric(), DarkMatter.numeric()) :: Decimal.t()
  def decimal_sub(x0, x1) do
    x0
    |> Conversion.cast_decimal()
    |> Decimal.sub(Conversion.cast_decimal(x1))
    |> Decimal.normalize()
  end

  @doc """
  Sum Decimal
  """
  @spec decimal_sum([DarkMatter.numeric()], DarkMatter.strict_numeric()) :: Decimal.t()
  def decimal_sum(decimals, default \\ 0)

  def decimal_sum([], default) when is_strict_numeric(default) do
    Conversion.cast_decimal(default)
  end

  def decimal_sum(decimals, default) when is_list(decimals) and is_strict_numeric(default) do
    decimals
    |> Enum.map(&Conversion.cast_decimal!/1)
    |> Enum.reduce(Conversion.cast_decimal(0), &Decimal.add/2)
    |> Decimal.normalize()
  end

  @doc """
  Calculate the percentage.
  """
  @spec decimal_percentage(DarkMatter.numeric(), DarkMatter.numeric()) :: Decimal.t()
  def decimal_percentage(allocation, total) do
    allocation
    |> to_percentage()
    |> decimal_div(total)
  end

  @doc """
  Cast from a percentage.
  """
  @spec from_percentage(DarkMatter.numeric()) :: Decimal.t()
  def from_percentage(amount) do
    decimal_div(amount, 100)
  end

  @doc """
  Cast to a percentage.
  """
  @spec to_percentage(DarkMatter.numeric()) :: Decimal.t()
  def to_percentage(amount) do
    decimal_mult(amount, 100)
  end
end
