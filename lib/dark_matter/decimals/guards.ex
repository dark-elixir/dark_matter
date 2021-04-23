defmodule DarkMatter.Decimals.Guards do
  @moduledoc """
  Decimal guard functions
  """
  @moduledoc since: "1.0.8"

  @doc """
  Define a guard clause for checking decimal maps.
  """
  @doc guard: true
  @spec is_decimal_map(any()) :: Macro.t()
  defguard is_decimal_map(value)
           when is_map(value) and
                  is_map_key(value, :sign) and
                  is_map_key(value, :coef) and
                  is_map_key(value, :exp) and
                  :erlang.map_get(:sign, value) in [-1, 1] and
                  is_integer(:erlang.map_get(:coef, value)) and
                  is_integer(:erlang.map_get(:exp, value)) and
                  :erlang.map_get(:coef, value) >= 0 and
                  :erlang.map_get(:exp, value) >= 0
end
