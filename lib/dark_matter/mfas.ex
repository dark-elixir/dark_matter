defmodule DarkMatter.Mfas do
  @moduledoc """
  Utils for working with `t:mfa/0`.
  """
  @moduledoc since: "1.0.5"

  import DarkMatter.Guards,
    only: [
      is_arity: 1,
      is_module: 1
    ]

  @type t() :: mfa()

  @doc """
  Define a guard clause for working with `t:mfa/0`.

  ## Examples

      iex> is_mfa({Kernel, :+, 2})
      true

      iex> is_mfa([])
      false
  """
  @doc guard: true
  @spec is_mfa(any()) :: Macro.t()
  defguard is_mfa(value)
           when is_tuple(value) and tuple_size(value) == 3 and
                  is_module(elem(value, 0)) and
                  is_atom(elem(value, 1)) and
                  is_arity(elem(value, 2))

  @doc """
  Define a check for pattern matching on `t:mfa/0`.

  ## Examples

      iex> is_mfa({Kernel, :+, 2})
      true

      iex> is_mfa([])
      false
  """
  @spec mfa?(any()) :: boolean()
  def mfa?(value) do
    is_mfa(value)
  end
end
