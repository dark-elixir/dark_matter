defmodule DarkMatter.Decimals.ConversionTest do
  @moduledoc """
  Test for DarkMatter.Decimals.Conversion
  """

  use ExUnit.Case, async: true

  alias DarkMatter.Decimals.Conversion

  @cases %{
    normal: [
      # Base 10 integers
      {0, %Decimal{sign: 1, coef: 0, exp: 0}},
      {10, %Decimal{sign: 1, coef: 10, exp: 0}},
      {100, %Decimal{sign: 1, coef: 100, exp: 0}},
      {1_000, %Decimal{sign: 1, coef: 1000, exp: 0}},
      {-10, %Decimal{sign: -1, coef: 10, exp: 0}},
      {-100, %Decimal{sign: -1, coef: 100, exp: 0}},
      {-1_000, %Decimal{sign: -1, coef: 1000, exp: 0}},

      # Floats
      {1.234, %Decimal{sign: 1, coef: 1234, exp: -3}},
      {0.000185711, %Decimal{sign: 1, coef: 185_711, exp: -9}},
      {-3.1423, %Decimal{sign: -1, coef: 31_423, exp: -4}},

      # Base 10 integers (string)
      {"0", %Decimal{sign: 1, coef: 0, exp: 0}},
      {"10", %Decimal{sign: 1, coef: 10, exp: 0}},
      {"100", %Decimal{sign: 1, coef: 100, exp: 0}},
      {"1_000", %Decimal{sign: 1, coef: 1000, exp: 0}},
      {"-10", %Decimal{sign: -1, coef: 10, exp: 0}},
      {"-100", %Decimal{sign: -1, coef: 100, exp: 0}},
      {"-1_000", %Decimal{sign: -1, coef: 1000, exp: 0}},

      # Base 10 integers (string) (formatting)
      {"$0", %Decimal{sign: 1, coef: 0, exp: 0}},
      {"$10", %Decimal{sign: 1, coef: 10, exp: 0}},
      {"$100", %Decimal{sign: 1, coef: 100, exp: 0}},
      {"$1_000", %Decimal{sign: 1, coef: 1000, exp: 0}},
      {"-$10", %Decimal{sign: -1, coef: 10, exp: 0}},
      {"$-100", %Decimal{sign: -1, coef: 100, exp: 0}},
      {"-$1,000", %Decimal{sign: -1, coef: 1000, exp: 0}},

      # Base 10 integers (decimal) (==)
      {%Decimal{sign: 1, coef: 0, exp: 0}, %Decimal{sign: 1, coef: 0, exp: 0}},
      {%Decimal{sign: 1, coef: 10, exp: 0}, %Decimal{sign: 1, coef: 10, exp: 0}},
      {%Decimal{sign: 1, coef: 100, exp: 0}, %Decimal{sign: 1, coef: 100, exp: 0}},
      {%Decimal{sign: 1, coef: 1000, exp: 0}, %Decimal{sign: 1, coef: 1000, exp: 0}},
      {%Decimal{sign: -1, coef: 10, exp: 0}, %Decimal{sign: -1, coef: 10, exp: 0}},
      {%Decimal{sign: -1, coef: 100, exp: 0}, %Decimal{sign: -1, coef: 100, exp: 0}},
      {%Decimal{sign: -1, coef: 1000, exp: 0}, %Decimal{sign: -1, coef: 1000, exp: 0}}
    ],
    normalized: [
      # Base 10 integers
      {0, %Decimal{sign: 1, coef: 0, exp: 0}},
      {10, %Decimal{sign: 1, coef: 1, exp: 1}},
      {100, %Decimal{sign: 1, coef: 1, exp: 2}},
      {1_000, %Decimal{sign: 1, coef: 1, exp: 3}},
      {-10, %Decimal{sign: -1, coef: 1, exp: 1}},
      {-100, %Decimal{sign: -1, coef: 1, exp: 2}},
      {-1_000, %Decimal{sign: -1, coef: 1, exp: 3}},

      # Floats
      {1.234, %Decimal{sign: 1, coef: 1234, exp: -3}},
      {0.000185711, %Decimal{sign: 1, coef: 185_711, exp: -9}},
      {-3.1423, %Decimal{sign: -1, coef: 31_423, exp: -4}},

      # Base 10 integers (string)
      {"0", %Decimal{sign: 1, coef: 0, exp: 0}},
      {"10", %Decimal{sign: 1, coef: 1, exp: 1}},
      {"100", %Decimal{sign: 1, coef: 1, exp: 2}},
      {"1_000", %Decimal{sign: 1, coef: 1, exp: 3}},
      {"-10", %Decimal{sign: -1, coef: 1, exp: 1}},
      {"-100", %Decimal{sign: -1, coef: 1, exp: 2}},
      {"-1_000", %Decimal{sign: -1, coef: 1, exp: 3}},

      # Base 10 integers (string) (formatting)
      {"$0", %Decimal{sign: 1, coef: 0, exp: 0}},
      {"$10", %Decimal{sign: 1, coef: 1, exp: 1}},
      {"$100", %Decimal{sign: 1, coef: 1, exp: 2}},
      {"$1_000", %Decimal{sign: 1, coef: 1, exp: 3}},
      {"-$10", %Decimal{sign: -1, coef: 1, exp: 1}},
      {"$-100", %Decimal{sign: -1, coef: 1, exp: 2}},
      {"-$1,000", %Decimal{sign: -1, coef: 1, exp: 3}},

      # Base 10 integers (decimal) (==)
      {%Decimal{sign: 1, coef: 0, exp: 0}, %Decimal{sign: 1, coef: 0, exp: 0}},
      {%Decimal{sign: 1, coef: 10, exp: 0}, %Decimal{sign: 1, coef: 1, exp: 1}},
      {%Decimal{sign: 1, coef: 100, exp: 0}, %Decimal{sign: 1, coef: 1, exp: 2}},
      {%Decimal{sign: 1, coef: 1000, exp: 0}, %Decimal{sign: 1, coef: 1, exp: 3}},
      {%Decimal{sign: -1, coef: 10, exp: 0}, %Decimal{sign: -1, coef: 1, exp: 1}},
      {%Decimal{sign: -1, coef: 100, exp: 0}, %Decimal{sign: -1, coef: 1, exp: 2}},
      {%Decimal{sign: -1, coef: 1000, exp: 0}, %Decimal{sign: -1, coef: 1, exp: 3}}
    ]
  }

  describe ".cast_decimal/1" do
    for {given, expected} <- @cases.normalized do
      test "given #{inspect(given)} it returns #{inspect(expected)}" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Conversion.cast_decimal(given) == expected
      end
    end
  end

  describe ".cast_decimal/2 (:normal)" do
    @option :normal
    for {given, expected} <- @cases.normal do
      test "given #{inspect(given)} it returns #{inspect(expected)}" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Conversion.cast_decimal(given, @option) == expected
      end
    end
  end

  describe ".cast_decimal/2 (:reduced)" do
    @option :reduced
    for {given, expected} <- @cases.normalized do
      test "given #{inspect(given)} it returns #{inspect(expected)}" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Conversion.cast_decimal(given, @option) == expected
      end
    end
  end

  describe ".cast_decimal!/1" do
    for {given, expected} <- @cases.normalized do
      test "given #{inspect(given)} it returns #{inspect(expected)}" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Conversion.cast_decimal(given) == expected
      end
    end
  end

  describe ".cast_decimal!/2 (:normal)" do
    @option :normal
    for {given, expected} <- @cases.normal do
      test "given #{inspect(given)} it returns #{inspect(expected)}" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Conversion.cast_decimal!(given, @option) == expected
      end
    end
  end

  describe ".cast_decimal!/2 (:reduced)" do
    @option :reduced
    for {given, expected} <- @cases.normalized do
      test "given #{inspect(given)} it returns #{inspect(expected)}" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Conversion.cast_decimal!(given, @option) == expected
      end
    end
  end

  describe ".cast_decimal_ok/1" do
    for {given, expected} <- @cases.normalized do
      test "given #{inspect(given)} it returns #{inspect(expected)}" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Conversion.cast_decimal_ok(given) == {:ok, expected}
      end
    end
  end

  describe ".cast_decimal_ok/2 (:normal)" do
    @option :normal
    for {given, expected} <- @cases.normal do
      test "given #{inspect(given)} it returns #{inspect(expected)}" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Conversion.cast_decimal_ok(given, @option) == {:ok, expected}
      end
    end
  end

  describe ".cast_decimal_ok/2 (:reduced)" do
    @option :reduced
    for {given, expected} <- @cases.normalized do
      test "given #{inspect(given)} it returns #{inspect(expected)}" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Conversion.cast_decimal_ok(given, @option) == {:ok, expected}
      end
    end
  end

  describe ".decimal_cmp/2 " do
    for {given, expected} <- @cases.normal do
      test "given #{inspect(given)} equals #{inspect(expected)} (normal)" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Conversion.decimal_cmp(given, expected) == :eq
      end
    end

    for {given, expected} <- @cases.normalized do
      test "given #{inspect(given)} equals #{inspect(expected)} (normalized)" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Conversion.decimal_cmp(given, expected) == :eq
      end
    end
  end

  describe ".decimal_equal?/2 " do
    for {given, expected} <- @cases.normal do
      test "given #{inspect(given)} equals #{inspect(expected)} (normal)" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Conversion.decimal_equal?(given, expected) == true
      end
    end

    for {given, expected} <- @cases.normalized do
      test "given #{inspect(given)} equals #{inspect(expected)} (normalized)" do
        given = unquote(Macro.escape(given))
        expected = unquote(Macro.escape(expected))

        assert Conversion.decimal_equal?(given, expected) == true
      end
    end
  end
end
