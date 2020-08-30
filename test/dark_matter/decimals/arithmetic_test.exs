defmodule DarkMatter.Decimals.ArithmeticTest do
  @moduledoc """
  Test for DarkMatter.Decimals.Arithmetic
  """

  use ExUnit.Case, async: true

  alias DarkMatter.Decimals.Arithmetic
  alias DarkMatter.Decimals.Conversion

  describe ".decimal_add/2" do
  end

  describe ".decimal_avg/2" do
  end

  describe ".decimal_div/2" do
    test "given nil dividend but default" do
      dividend = nil
      divisor = 1
      default = 2
      assert Arithmetic.decimal_div(dividend, divisor, default) == Conversion.cast_decimal("2")
    end

    test "given nil divisor" do
      dividend = 1
      divisor = nil
      default = 3
      assert Arithmetic.decimal_div(dividend, divisor, default) == Conversion.cast_decimal("3")
    end
  end

  describe ".decimal_mult/2" do
  end

  describe ".decimal_sub/2" do
  end

  describe ".decimal_sum/2" do
  end

  describe ".from_percentage/2" do
  end

  describe ".to_percentage/2" do
  end
end
