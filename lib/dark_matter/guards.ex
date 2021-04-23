defmodule DarkMatter.Guards do
  @moduledoc """
  Utils for working with guard clauses.
  """
  @moduledoc since: "1.0.5"

  import DarkMatter.Decimals.Guards

  @doc """
  Define a guard clause for working with `t:module/0`.

  ## Examples

      iex> is_module(Kernel)
      true

      iex> is_arity(nil)
      false

      iex> is_arity(false)
      false
  """
  @doc guard: true
  @spec is_module(any()) :: Macro.t()
  defguard is_module(value)
           when is_atom(value) and
                  value not in [nil]

  @doc """
  Define a guard clause for working with `t:arity/0`.

  ## Examples

      iex> is_arity(3)
      true

      iex> is_arity(257)
      false
  """
  @doc guard: true
  @spec is_arity(any()) :: Macro.t()
  defguard is_arity(value)
           when is_integer(value) and
                  value >= 0 and
                  value <= 255

  @doc """
  Define a guard clause for working with `t:pos_integer/0`.

  ## Examples

      iex> is_pos_integer(1)
      true

      iex> is_pos_integer(0)
      false

      iex> is_pos_integer(-1)
      false
  """
  @doc guard: true
  @spec is_pos_integer(any()) :: Macro.t()
  defguard is_pos_integer(value)
           when is_integer(value) and
                  value >= 1

  @doc """
  Define a guard clause for working with `t:non_neg_integer/0`.

  ## Examples

      iex> is_non_neg_integer(3)
      true

      iex> is_non_neg_integer(0)
      true

      iex> is_non_neg_integer(-100)
      false
  """
  @doc guard: true
  @spec is_non_neg_integer(any()) :: Macro.t()
  defguard is_non_neg_integer(value)
           when is_integer(value) and
                  value >= 0

  @doc """
  Define a guard clause for working with `t:neg_integer/0`.

  ## Examples

      iex> is_neg_integer(-5)
      true

      iex> is_neg_integer(0)
      false

      iex> is_neg_integer(99)
      false
  """
  @doc guard: true
  @spec is_neg_integer(any()) :: Macro.t()
  defguard is_neg_integer(value)
           when is_integer(value) and
                  value < 0

  @doc """
  Define a guard clause for working with `Ecto` based `t:struct/0`.

  ## Examples

      ...>
      iex> is_ecto_struct(%{__struct__: MyStruct, __meta__: %Ecto.Schema.Metadata{}})
      true

      iex> is_ecto_struct(%{__struct__: MyStruct, __meta__: nil})
      false

      iex> is_ecto_struct(%{})
      false

      iex> is_ecto_struct(%{__struct__: MyStruct, __meta__: %Ecto.Schema.Metadata{}}, MyStruct)
      true

      iex> is_ecto_struct(%{__struct__: MyStruct, __meta__: nil}, MyStruct)
      false

      iex> is_ecto_struct(%{})
      false
  """
  @doc guard: true
  @spec is_ecto_struct(any()) :: Macro.t()
  defguard is_ecto_struct(value)
           when is_struct(value) and
                  is_map_key(value, :__meta__) and
                  is_struct(:erlang.map_get(:__meta__, value), Ecto.Schema.Metadata)

  @spec is_ecto_struct(any(), module()) :: Macro.t()
  defguard is_ecto_struct(value, module)
           when is_struct(value, module) and
                  is_map_key(value, :__meta__) and
                  is_struct(:erlang.map_get(:__meta__, value), Ecto.Schema.Metadata)

  @doc """
  Define a guard clause for working with strict numerics.

  ## Examples

      iex> is_strict_numeric(0)
      true

      iex> is_strict_numeric(1.1)
      true

      iex> is_strict_numeric(%Decimal{})
      true

      iex> is_strict_numeric("2.0")
      false
  """
  @doc guard: true
  @spec is_strict_numeric(any()) :: Macro.t()
  defguard is_strict_numeric(value)
           when is_integer(value) or
                  is_float(value) or
                  is_struct(value, Decimal)

  @doc """
  Define a guard clause for working with numerics.

  ## Examples

      iex> is_numeric(0)
      true

      iex> is_numeric(1.1)
      true

      iex> is_numeric(%Decimal{sign: 1, coef: 1,  exp: 1})
      true

      iex> is_numeric("2.0")
      true

      iex> is_numeric(%{sign: 1, coef: 1,  exp: 1})
      true

      # Can't handle this currently with macros.
      iex> is_numeric("2.0.0")
      true
  """
  @doc guard: true
  @spec is_numeric(any()) :: Macro.t()
  defguard is_numeric(value)
           when is_strict_numeric(value) or
                  is_decimal_map(value) or
                  is_binary(value)

  @doc """
  Delegates to `DarkMatter.Guards.is_module/1`.
  """
  @spec module?(any()) :: boolean()
  def module?(value), do: is_module(value)

  @doc """
  Delegates to `DarkMatter.Guards.is_arity/1`.
  """
  @spec arity?(any()) :: boolean()
  def arity?(value), do: is_arity(value)

  @doc """
  Delegates to `DarkMatter.Guards.is_pos_integer/1`.
  """
  @spec pos_integer?(any()) :: boolean()
  def pos_integer?(value), do: is_pos_integer(value)

  @doc """
  Delegates to `DarkMatter.Guards.is_non_neg_integer/1`.
  """
  @spec non_neg_integer?(any()) :: boolean()
  def non_neg_integer?(value), do: is_non_neg_integer(value)

  @doc """
  Delegates to `DarkMatter.Guards.is_neg_integer/1`.
  """
  @spec neg_integer?(any()) :: boolean()
  def neg_integer?(value), do: is_neg_integer(value)

  @doc """
  Delegates to `DarkMatter.Guards.is_ecto_struct/1`.
  """
  @spec ecto_struct?(any()) :: boolean()
  def ecto_struct?(value), do: is_ecto_struct(value)

  @doc """
  Delegates to `DarkMatter.Guards.is_ecto_struct/2`.
  """
  @spec ecto_struct?(any(), module()) :: boolean()
  def ecto_struct?(value, module), do: is_ecto_struct(value, module)

  @doc """
  Delegates to `DarkMatter.Guards.is_strict_numeric/1`.
  """
  @spec strict_numeric?(any()) :: boolean()
  def strict_numeric?(value), do: is_strict_numeric(value)

  @doc """
  Delegates to `DarkMatter.Guards.is_numeric/1`.
  """
  @spec numeric?(any()) :: boolean()
  def numeric?(value), do: is_numeric(value)
end
