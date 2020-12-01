defmodule DarkMatter.Guards do
  @moduledoc """
  Utils for working with guard clauses.
  """
  @moduledoc since: "1.0.5"

  @doc """
  Define a guard clause for working with `t:module/0`.
  """
  @doc guard: true
  @spec is_module(any()) :: Macro.t()
  defguard is_module(any)
           when is_atom(any)

  @doc """
  Define a guard clause for working with function name atoms.
  """
  @doc guard: true
  @spec is_fun_atom(any()) :: Macro.t()
  defguard is_fun_atom(any)
           when is_atom(any)

  @doc """
  Define a guard clause for working with `t:arity/0`.
  """
  @doc guard: true
  @spec is_arity(any()) :: Macro.t()
  defguard is_arity(any)
           when is_integer(any) and
                  any >= 0 and
                  any <= 255

  @doc """
  Define a guard clause for working with `t:pos_integer/0`.
  """
  @doc guard: true
  @spec is_pos_integer(any()) :: Macro.t()
  defguard is_pos_integer(any)
           when is_integer(any) and
                  any >= 1

  @doc """
  Define a guard clause for working with `t:non_neg_integer/0`.
  """
  @doc guard: true
  @spec is_non_neg_integer(any()) :: Macro.t()
  defguard is_non_neg_integer(any)
           when is_integer(any) and
                  any >= 0

  @doc """
  Define a guard clause for working with `t:neg_integer/0`.
  """
  @doc guard: true
  @spec is_neg_integer(any()) :: Macro.t()
  defguard is_neg_integer(any)
           when is_integer(any) and
                  any < 0

  @doc """
  Define a guard clause for working with `Ecto` based `t:struct/0`.
  """
  @doc guard: true
  @spec is_ecto_struct(any()) :: Macro.t()
  defguard is_ecto_struct(struct)
           when is_struct(struct) and
                  is_map_key(struct, :__meta__)

  @spec is_ecto_struct(any(), module()) :: Macro.t()
  defguard is_ecto_struct(struct, module)
           when is_struct(struct, module) and
                  is_map_key(struct, :__meta__)
end
