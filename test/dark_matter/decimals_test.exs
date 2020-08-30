defmodule DarkMatter.DecimalsTest do
  @moduledoc """
  Test for DarkMatter.Decimals
  """

  use ExUnit.Case, async: true
  import Kernel, except: [to_string: 1]
  doctest DarkMatter.Decimals, import: true
end
