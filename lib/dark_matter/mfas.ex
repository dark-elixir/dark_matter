defmodule DarkMatter.Mfas do
  @moduledoc """
  Utils for working with `t:mfa/0`.
  """
  @moduledoc since: "1.0.5"

  import DarkMatter.Guards,
    only: [
      is_module: 1,
      is_fun_atom: 1,
      is_arity: 1
    ]

  @type t() :: mfa()

  @doc """
  Define a guard clause for working with `t:mfa/0`.
  """
  @doc guard: true
  @spec is_mfa(any()) :: Macro.t()
  defguard is_mfa(mfa)
           when is_tuple(mfa) and tuple_size(mfa) == 3 and
                  is_module(elem(mfa, 0)) and
                  is_fun_atom(elem(mfa, 1)) and
                  is_arity(elem(mfa, 2))

  @doc """
  Define a check for pattern matching on `t:mfa/0`.
  """
  @spec mfa?(any()) :: boolean()
  def mfa?(mfa), do: is_mfa(mfa)
end
