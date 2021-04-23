defmodule DarkMatter.Decimals.Variance do
  @moduledoc """
  Decimal variance functions
  """
  @moduledoc since: "1.0.0"

  alias DarkMatter.Decimals.Arithmetic
  alias DarkMatter.Decimals.Comparison
  alias DarkMatter.Decimals.Conversion

  @type minmax() :: {DarkMatter.strict_numeric(), DarkMatter.strict_numeric()}

  @defaults %{
    variance: {0, 0},
    variance_percent: {0, 100},
    max_variance_percent: {100, 100}
  }

  @doc """
  Calculate variance
  """
  @spec variance([DarkMatter.numeric()]) :: Decimal.t()
  def variance([]) do
    @defaults.variance
    |> elem(0)
    |> Conversion.cast_decimal()
  end

  def variance([_]) do
    @defaults.variance
    |> elem(1)
    |> Conversion.cast_decimal()
  end

  def variance(list) when is_list(list) do
    list
    |> Enum.map(&Conversion.to_number/1)
    |> Numerix.Statistics.variance()
    |> Conversion.cast_decimal()
  end

  @doc """
  Variance percent relative to the mean
  """
  @spec variance_percent([DarkMatter.numeric()], minmax()) :: Decimal.t()
  def variance_percent(list, default \\ @defaults.variance_percent)

  def variance_percent([], {default, _}) do
    Conversion.cast_decimal(default)
  end

  def variance_percent([_], {_, default}) do
    Conversion.cast_decimal(default)
  end

  def variance_percent(list, _default) when is_list(list) do
    mean = Arithmetic.decimal_avg(list)

    list
    |> Enum.map(&Conversion.cast_decimal!/1)
    |> Enum.map(fn item ->
      if Comparison.decimal_equal?(item, 0) do
        Decimal.new(0)
      else
        item
        |> Arithmetic.decimal_sub(mean)
        |> Decimal.abs()
        |> Arithmetic.decimal_div(item)
      end
    end)
    |> Arithmetic.decimal_avg()
    |> Arithmetic.to_percentage()
    |> Arithmetic.decimal_add(100)
  end

  @doc """
  Determine if a list is a uniform set of `t:DarkMatter.numeric/0`.
  """
  @spec decimal_uniform?([DarkMatter.numeric()]) :: boolean()
  def decimal_uniform?([]) do
    true
  end

  def decimal_uniform?([_]) do
    true
  end

  def decimal_uniform?(list) when is_list(list) do
    list
    |> Enum.map(&Conversion.cast_decimal!/1)
    |> MapSet.new()
    |> MapSet.size()
    |> Comparison.decimal_equal?(1)
  end

  @doc """
  Max entries percent variance relative to the mean
  """
  @spec max_variance_percent([DarkMatter.numeric()], minmax()) :: Decimal.t()
  def max_variance_percent(list, default \\ @defaults.max_variance_percent)

  def max_variance_percent([], {default, _}) do
    Conversion.cast_decimal(default)
  end

  def max_variance_percent([_], {_, default}) do
    Conversion.cast_decimal(default)
  end

  def max_variance_percent(list, _default) when is_list(list) do
    mean = Arithmetic.decimal_avg(list)

    cond do
      decimal_uniform?(list) ->
        Conversion.cast_decimal(100)

      Comparison.decimal_equal?(mean, 0) ->
        Conversion.cast_decimal(0)

      true ->
        list
        |> Enum.map(&Conversion.cast_decimal!/1)
        |> Enum.map(&Arithmetic.decimal_sub(&1, mean))
        |> Enum.max_by(&Decimal.abs/1)
        |> Arithmetic.decimal_div(mean)
        |> Arithmetic.to_percentage()
        |> Arithmetic.decimal_add(100)
    end
  end
end
