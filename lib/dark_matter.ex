defmodule DarkMatter do
  @moduledoc """
  Common Utility Toolbelt
  """

  alias DarkMatter.Decimals

  @type numeric() :: strict_numeric() | String.t() | Decimals.decimal_map()
  @type maybe_numeric() :: numeric() | nil
  @type strict_numeric() :: integer() | float() | Decimal.t()
  @type maybe_number() :: number() | nil
end
