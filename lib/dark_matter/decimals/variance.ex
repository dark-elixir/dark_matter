defmodule DarkMatter.Decimals.Variance do
  @moduledoc """
  Decimal variance functions
  """
  @moduledoc since: "1.0.0"

  alias DarkMatter.Decimals.Arithmetic
  alias DarkMatter.Decimals.Conversion

  @defaults %{
    variance: {0, 0},
    variance_percent: {0, 100},
    max_variance_percent: {100, 100}
  }

  @doc """
  Calculate variance
  """
  def variance([]), do: @defaults.variance |> elem(0) |> Conversion.cast_decimal()
  def variance([_]), do: @defaults.variance |> elem(1) |> Conversion.cast_decimal()

  def variance(list) when is_list(list) do
    list
    |> Enum.map(&Conversion.to_number/1)
    |> Numerix.Statistics.variance()
    |> Conversion.cast_decimal()
  end

  @doc """
  Variance percent relative to the mean
  """

  def variance_percent(list, default \\ @defaults.variance_percent)
  def variance_percent([], {default, _}), do: Conversion.cast_decimal(default)
  def variance_percent([_], {_, default}), do: Conversion.cast_decimal(default)

  def variance_percent(list, _default) when is_list(list) do
    mean = Arithmetic.decimal_avg(list)

    list
    |> Enum.map(&Conversion.cast_decimal!/1)
    |> Enum.map(fn item ->
      if Decimal.compare(item, 0) == :eq do
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

  def decimal_uniform?([]), do: true
  def decimal_uniform?([_]), do: true

  def decimal_uniform?(list) when is_list(list) do
    count =
      list
      |> Enum.map(&Conversion.cast_decimal!/1)
      |> MapSet.new()
      |> MapSet.size()

    count == 1
  end

  @doc """
  Max entries percent variance relative to the mean
  """

  def max_variance_percent(list, default \\ @defaults.max_variance_percent)
  def max_variance_percent([], {default, _}), do: Conversion.cast_decimal(default)
  def max_variance_percent([_], {_, default}), do: Conversion.cast_decimal(default)

  def max_variance_percent(list, _default) when is_list(list) do
    mean = Arithmetic.decimal_avg(list)

    cond do
      decimal_uniform?(list) ->
        Conversion.cast_decimal(100)

      Decimal.compare(mean, 0) == :eq ->
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
