defmodule DarkMatter.Decimals.VarianceTest do
  @moduledoc """
  Test for DarkMatter.Decimals.Variance
  """

  use ExUnit.Case, async: true

  alias DarkMatter.Decimals.Conversion
  alias DarkMatter.Decimals.Variance

  @cases %{
    variance: [
      {[], "0"},
      {[25_000], "0"},
      {[500, 500, 500], "0"},
      {[500, 510, 520], "100"},
      {[500, 5_000, 25_000], "170083333.3333333"},
      {[0, 5_000, 25_000, 25_000, 35_000, 45_000, 88_888], "877540458.6666666"},
      {[100, 200, 240], "5200"}
    ],
    variance_percent: [
      {[], "0"},
      {[25_000], "100"},
      {[500, 500, 500], "100"},
      {[500, 510, 520], "101.307692307692307692307692308"},
      {[500, 5_000, 25_000], "798.6666666666666666666666667"},
      {[0, 5_000, 25_000, 25_000, 35_000, 45_000, 88_888], "199.587318211141295086420252"},
      {[100, 200, 240], "138.3333333333333333333333333"}
    ],
    max_variance_percent: [
      {[], "100"},
      {[25_000], "100"},
      {[500, 500, 500], "100"},
      {[500, 510, 520], "98.03921568627450980392156863"},
      {[500, 5_000, 25_000], "245.901639344262295081967213"},
      {[0, 5_000, 25_000, 25_000, 35_000, 45_000, 88_888], "277.9139569784892446223111556"},
      {[100, 200, 240], "55.55555555555555555555555556"}
    ]
  }

  describe ".variance/1" do
    for {given, expected} <- @cases.variance do
      test "given #{inspect(given)} it returns #{inspect(expected)}" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Variance.variance(given) == Conversion.cast_decimal(expected)
      end
    end
  end

  describe ".variance_percent/1" do
    for {given, expected} <- @cases.variance_percent do
      test "given #{inspect(given)} it returns #{inspect(expected)}" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Variance.variance_percent(given) == Conversion.cast_decimal(expected)
      end
    end
  end

  describe ".max_variance_percent/1" do
    for {given, expected} <- @cases.max_variance_percent do
      test "given #{inspect(given)} it returns #{inspect(expected)}" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Variance.max_variance_percent(given) == Conversion.cast_decimal(expected)
      end
    end

    test "given a non-uniform mean of 0 it returns 0" do
      given = [-1, 0, 1]
      assert Variance.max_variance_percent(given) == Conversion.cast_decimal("0")
    end
  end
end
