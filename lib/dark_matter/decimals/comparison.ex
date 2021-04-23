defmodule DarkMatter.Decimals.Comparison do
  @moduledoc """
  Decimal comparison functions
  """
  @moduledoc since: "1.0.8"

  import DarkMatter.Guards, only: [is_numeric: 1]

  alias DarkMatter.Decimals.Conversion
  alias DarkMatter.Deps

  @type comparison() :: :eq | :gt | :lt

  @doc """
  Determines if two `t:DarkMatter.DarkMatter.numeric/0` are equivalent.
  """
  @spec decimal_equal?(DarkMatter.numeric(), DarkMatter.numeric()) :: boolean()
  def decimal_equal?(x, y) do
    decimal_compare(x, y) == :eq
  end

  @doc """
  Compare two decimals `x` and `y`.
  """
  @spec decimal_compare(DarkMatter.numeric(), DarkMatter.numeric()) :: comparison()
  cond do
    Deps.version_match?(:decimal, ">= 2.0.0") ->
      def decimal_compare(x, y) when is_numeric(x) and is_numeric(y) do
        Decimal.compare(Conversion.cast_decimal(x), Conversion.cast_decimal(y))
      end

    Deps.version_match?(:decimal, ">= 1.0.0") ->
      @spec decimal_compare(DarkMatter.numeric(), DarkMatter.numeric()) :: comparison()
      def decimal_compare(x, y) when is_numeric(x) and is_numeric(y) do
        Decimal.cmp(Conversion.cast_decimal(x), Conversion.cast_decimal(y))
      end
  end

  @doc """
  Parse a given `binary` into a `t:Decimal.t/0`.
  """
  @spec decimal_parse(String.t()) :: Decimal.t() | :error
  cond do
    Deps.version_match?(:decimal, ">= 2.0.0") ->
      def decimal_parse(binary) when is_binary(binary) do
        case Decimal.parse(binary) do
          {%Decimal{} = normal_decimal, ""} -> normal_decimal
          {%Decimal{} = _normal_decimal, _rounding} -> :error
        end
      end

    Deps.version_match?(:decimal, ">= 1.0.0") ->
      @spec decimal_parse(String.t()) :: Decimal.t() | :error
      def decimal_parse(binary) when is_binary(binary) do
        case Decimal.parse(binary) do
          {:ok, %Decimal{} = normal_decimal} -> normal_decimal
          :error -> :error
        end
      end
  end
end
