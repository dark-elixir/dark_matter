defmodule DarkMatter.Decimals do
  @moduledoc """
  Decimal Utils
  """
  @moduledoc since: "1.0.0"

  alias DarkMatter.Decimals.Arithmetic
  alias DarkMatter.Decimals.Comparison
  alias DarkMatter.Decimals.Conversion
  alias DarkMatter.Decimals.Variance

  @type decimal_map() :: %{sign: -1 | 1, coef: non_neg_integer(), exp: non_neg_integer()}

  @doc """
  Casts an `x` of type `t:DarkMatter.numeric/0` into a `t:Decimal.t/0`.

  ## Examples

      iex> cast_decimal(0.11)
      %Decimal{coef: 11, exp: -2}

      iex> cast_decimal(%{sign: -1, coef: 11, exp: -2})
      %Decimal{sign: -1, coef: 11, exp: -2}

      iex> cast_decimal(%Decimal{sign: -1, coef: 11, exp: -2})
      %Decimal{sign: -1, coef: 11, exp: -2}

      iex> cast_decimal(1_000, :normal)
      %Decimal{coef: 1_000, exp: 0}

      iex> cast_decimal(1_000, :reduced)
      %Decimal{coef: 1, exp: 3}
  """
  @spec cast_decimal(any()) :: :error | nil | Decimal.t()
  defdelegate cast_decimal(x), to: Conversion

  @spec cast_decimal(any(), Conversion.conversion_modes()) :: :error | nil | Decimal.t()
  defdelegate cast_decimal(x, mode), to: Conversion

  @doc """
  Casts an `x` of type `t:DarkMatter.numeric/0` into a `t:Decimal.t/0`.

  Raises `ArgumentError` if given a non-numeric.

  ## Examples

      iex> cast_decimal!(0.11)
      %Decimal{coef: 11, exp: -2}

      iex> cast_decimal!(nil)
      ** (ArgumentError) invalid argument nil

      iex> cast_decimal!(1_000, :normal)
      %Decimal{coef: 1_000, exp: 0}

      iex> cast_decimal!(1_000, :reduced)
      %Decimal{coef: 1, exp: 3}
  """
  @spec cast_decimal!(any()) :: Decimal.t()
  defdelegate cast_decimal!(x), to: Conversion

  @spec cast_decimal!(any(), Conversion.conversion_modes()) :: Decimal.t()
  defdelegate cast_decimal!(x, mode), to: Conversion

  @doc """
  Casts an `x` of type `t:DarkMatter.numeric/0` into a `t:Decimal.t/0`.

  Returns `{:ok, %Decimal{}}` or `:error`

  ## Examples

      iex> cast_decimal_ok(0.11)
      {:ok, %Decimal{coef: 11, exp: -2}}

      iex> cast_decimal_ok(nil)
      :error

      iex> cast_decimal_ok(1_000, :normal)
      {:ok, %Decimal{coef: 1_000, exp: 0}}

      iex> cast_decimal_ok(1_000, :reduced)
      {:ok, %Decimal{coef: 1, exp: 3}}
  """
  @spec cast_decimal_ok(any()) :: {:ok, Decimal.t()} | :error
  defdelegate cast_decimal_ok(x), to: Conversion

  @spec cast_decimal_ok(any(), Conversion.conversion_modes()) :: {:ok, Decimal.t()} | :error
  defdelegate cast_decimal_ok(x, mode), to: Conversion

  @doc """
  Adds `x` and `y` of type `t:DarkMatter.numeric/0`.

  ## Examples

      iex> decimal_add(1, 2.5)
      %Decimal{coef: 35, exp: -1}
  """
  @spec decimal_add(DarkMatter.numeric(), DarkMatter.strict_numeric()) :: Decimal.t()
  defdelegate decimal_add(x, y), to: Arithmetic

  @doc """
  Averages a `list` of type `t:DarkMatter.numeric/0`.

  ## Examples

      iex> decimal_avg([8, 9, "10.5", 13.3, "$1.23", %Decimal{coef: 33}])
      %Decimal{coef: 12505, exp: -3}

      iex> decimal_avg([], 711)
      %Decimal{coef: 711, exp: 0}
  """
  @spec decimal_avg([DarkMatter.numeric()]) :: Decimal.t()
  defdelegate decimal_avg(list), to: Arithmetic

  @spec decimal_avg([DarkMatter.numeric()], DarkMatter.strict_numeric()) :: Decimal.t()
  defdelegate decimal_avg(list, default), to: Arithmetic

  @doc """
  Divides `x` and `y` of type `t:DarkMatter.numeric/0`.

  Returns `0` or `default` (if given) when dividing by `0`.

  ## Examples

      iex> decimal_div(30, 2.5)
      %Decimal{coef: 12, exp: 0}

      iex> decimal_div(0, 0)
      %Decimal{coef: 0, exp: 0}

      iex> decimal_div(0, 0, 989)
      %Decimal{coef: 989, exp: 0}
  """
  @spec decimal_div(DarkMatter.numeric(), DarkMatter.strict_numeric()) :: Decimal.t()
  defdelegate decimal_div(x, y), to: Arithmetic

  @spec decimal_div(DarkMatter.numeric(), DarkMatter.numeric(), DarkMatter.strict_numeric()) ::
          Decimal.t()
  defdelegate decimal_div(x, y, default), to: Arithmetic

  @doc """
  Multiplies `x` and `y` of type `t:DarkMatter.numeric/0`.

  ## Examples

      iex> decimal_mult(33, 21.523)
      %Decimal{coef: 710259, exp: -3}

      iex> decimal_mult(0, 0)
      %Decimal{coef: 0, exp: 0}

      iex> decimal_mult(1, 989)
      %Decimal{coef: 989, exp: 0}
  """
  @spec decimal_mult(DarkMatter.numeric(), DarkMatter.numeric()) :: Decimal.t()
  defdelegate decimal_mult(x, y), to: Arithmetic

  @doc """
  Subtracts `x` from `y` of type `t:DarkMatter.numeric/0`.

  ## Examples

      iex> decimal_sub(1, 2.5)
      %Decimal{sign: -1, coef: 15, exp: -1}
  """
  @spec decimal_sub(DarkMatter.numeric(), DarkMatter.numeric()) :: Decimal.t()
  defdelegate decimal_sub(x, y), to: Arithmetic

  @doc """
  Sums a `list` of type `t:DarkMatter.numeric/0`.

  ## Examples

      iex> decimal_sum([8, 9, "10.5", 13.3, "$1.23", %Decimal{coef: 33}])
      %Decimal{coef: 7503, exp: -2}

      iex> decimal_sum([], 711)
      %Decimal{coef: 711, exp: 0}
  """
  @spec decimal_sum([DarkMatter.numeric()]) :: Decimal.t()
  defdelegate decimal_sum(list), to: Arithmetic

  @spec decimal_sum([DarkMatter.numeric()], DarkMatter.strict_numeric()) :: Decimal.t()
  defdelegate decimal_sum(list, default), to: Arithmetic

  @doc """
  Gives the percentage of `x` relative to `y` of type `t:DarkMatter.numeric/0`.

  ## Examples

      iex> decimal_percentage(20, 100)
      %Decimal{coef: 2, exp: 1}
  """
  @spec decimal_percentage(DarkMatter.numeric(), DarkMatter.numeric()) :: Decimal.t()
  defdelegate decimal_percentage(x, y), to: Arithmetic

  @doc """
  Gives the decimal representation of an`x` of type `t:DarkMatter.numeric/0`.

  ## Examples

      iex> from_percentage(25)
      %Decimal{coef: 25, exp: -2}
  """
  @spec from_percentage(DarkMatter.numeric()) :: Decimal.t()
  defdelegate from_percentage(x), to: Arithmetic

  @doc """
  Gives the percentage representation of an`x` of type `t:DarkMatter.numeric/0`.

  ## Examples

      iex> to_percentage(0.25)
      %Decimal{coef: 25, exp: 0}
  """
  @spec to_percentage(DarkMatter.numeric()) :: Decimal.t()
  defdelegate to_percentage(x), to: Arithmetic

  @doc """
  Compares `x` of type `t:DarkMatter.numeric/0` to `y` of type `t:DarkMatter.numeric/0`.

  Returns `:eq` or `:gt` or `:lt`.

  ## Examples

      iex> decimal_compare(1, 1)
      :eq

      iex> decimal_compare(3, 0)
      :gt

      iex> decimal_compare(1, 2)
      :lt
  """
  @spec decimal_compare(DarkMatter.numeric(), DarkMatter.numeric()) :: Comparison.comparison()
  defdelegate decimal_compare(x, y), to: Comparison

  @doc """
  Determines if `x` of type `t:DarkMatter.numeric/0` is equivalent to `y` of type `t:DarkMatter.numeric/0`.

  Returns `true` or `false`.

  ## Examples

      iex> decimal_equal?(1, 1)
      true

      iex> decimal_equal?(3, 0)
      false

      iex> decimal_equal?(nil, 2)
      ** (FunctionClauseError) no function clause matching in DarkMatter.Decimals.Comparison.decimal_compare/2
  """
  @spec decimal_equal?(DarkMatter.numeric(), DarkMatter.numeric()) :: boolean()
  defdelegate decimal_equal?(x, y), to: Comparison

  @doc """
  Rounds an `x` of type `t:DarkMatter.numeric/0` based on the `opts`.

  Returns `round_up * ((x + (round_up/2)) / round_up)`

  ## Examples

      iex> decimal_round_ok(25.11, round_up: 50)
      {:ok, %Decimal{coef: 5, exp: 1}}

      iex> decimal_round_ok(50, round_up: 50)
      {:ok, %Decimal{coef: 5, exp: 1}}

      iex> decimal_round_ok(0, round_up: 50)
      {:ok, %Decimal{coef: 0, exp: 0}}
  """
  @spec decimal_round_ok(any(), Conversion.round_options()) :: {:ok, Decimal.t()} | :error
  defdelegate decimal_round_ok(x, opts), to: Conversion

  @doc """
  Rounds whether an `x` of type `t:DarkMatter.numeric/0` is already rounded according to `opts`

  ## Examples

      iex> rounded?(25.11, round_up: 50)
      false

      iex> rounded?(50, round_up: 50)
      true

      iex> rounded?(0, round_up: 50)
      true
  """
  @spec rounded?(any(), Conversion.round_options()) :: boolean()
  defdelegate rounded?(x, opts), to: Conversion

  @doc """
  Rounds an `x` of type `t:DarkMatter.numeric/0` into a `t:integer/0`.

  ## Examples

      iex> to_number(0.11)
      0.11

      iex> to_number(%Decimal{coef: 124_225, exp: -3})
      124.225

      iex> to_number("$0")
      0

      iex> to_number(nil)
      nil

      iex> to_number("xyz")
      nil
  """
  @spec to_number(DarkMatter.maybe_numeric()) :: DarkMatter.maybe_number()
  defdelegate to_number(x), to: Conversion

  @doc """
  Rounds an `x` of type `nil` or `t:DarkMatter.numeric/0` into a `t:String.t/0`.

  ## Examples

      iex> to_string(%Decimal{coef: 12, exp: -10})
      "0.0000000012"

      iex> to_string(%Decimal{coef: 124_225, exp: -3})
      "124.225"

      iex> to_string("$0")
      "0"

      iex> to_string(nil)
      nil

      iex> to_string("xyz")
      ** (Decimal.Error): number parsing syntax: "xyz"
  """
  @spec to_string(Conversion.stringable()) :: String.t() | nil
  defdelegate to_string(x), to: Conversion

  @spec to_string(Conversion.stringable(), Conversion.to_string_formatter()) :: String.t() | nil
  defdelegate to_string(x, mode), to: Conversion

  @doc """
  Determines the max variance percent of a `list` of type `t:DarkMatter.numeric/0`.

  Defaults to `100` if given an empty `list`.

  ## Examples

      iex> max_variance_percent([8, 9, "10.5", 13.3, "$1.23", %Decimal{coef: 33}])
      %Decimal{coef: 2638944422231107556977209116, exp: -25}

      iex> max_variance_percent([])
      %Decimal{coef: 1, exp: 2}

      iex> max_variance_percent([], {0, 100})
      %Decimal{coef: 0, exp: 0}

      iex> max_variance_percent([1], {0, 100})
      %Decimal{coef: 1, exp: 2}
  """
  @spec max_variance_percent([DarkMatter.numeric()]) :: Decimal.t()
  defdelegate max_variance_percent(list), to: Variance

  @spec max_variance_percent([DarkMatter.numeric()], Variance.minmax()) :: Decimal.t()
  defdelegate max_variance_percent(list, default), to: Variance

  @doc """
  Determines the variance percent of a `list` of type `t:DarkMatter.numeric/0`.

  Defaults to `0` if given an empty `list` or `100` if given a single item `list`.

  ## Examples

      iex> variance_percent([8, 9, "10.5", 13.3, "$1.23", %Decimal{coef: 33}])
      %Decimal{coef: 2831837255702387281334649757, exp: -25}

      iex> variance_percent([])
      %Decimal{coef: 0, exp: 0}

      iex> variance_percent([1_000])
      %Decimal{coef: 1, exp: 2}

      iex> variance_percent([], {0, 100})
      %Decimal{coef: 0, exp: 0}

      iex> variance_percent([1], {0, 100})
      %Decimal{coef: 1, exp: 2}
  """
  @spec variance_percent([DarkMatter.numeric()]) :: Decimal.t()
  defdelegate variance_percent(list), to: Variance

  @spec variance_percent([DarkMatter.numeric()], Variance.minmax()) :: Decimal.t()
  defdelegate variance_percent(list, default), to: Variance

  @doc """
  Determines the variance of a `list` of type `t:DarkMatter.numeric/0`.

  Defaults to `0` if given an empty or single item `list`.

  ## Examples

      iex> variance([8, 9, "10.5", 13.3, "$1.23", %Decimal{coef: 33}])
      %Decimal{coef: 11688055, exp: -5}

      iex> variance([])
      %Decimal{coef: 0, exp: 0}

      iex> variance([1_000])
      %Decimal{coef: 0, exp: 0}
  """
  @spec variance([DarkMatter.numeric()]) :: Decimal.t()
  defdelegate variance(list), to: Variance

  @doc """
  Annualize a monthly amount

  ## Examples

      iex> annualize(1)
      %Decimal{coef: 12, exp: 0}

      iex> annualize("$145.23")
      %Decimal{coef: 174276, exp: -2}

      iex> annualize(nil, 1)
      %Decimal{coef: 1, exp: 0}
  """
  @spec annualize(DarkMatter.numeric(), DarkMatter.strict_numeric()) :: Decimal.t()
  def annualize(x, default \\ 0)
  def annualize(nil, default), do: cast_decimal(default)
  def annualize(x, _default), do: decimal_mult(x, 12)
end
