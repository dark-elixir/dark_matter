defmodule DarkMatter.DatesTest do
  @moduledoc """
  Test for DarkMatter.Dates
  """

  use ExUnit.Case, async: true

  alias DarkMatter.Dates

  @cases [
    {"2020-05-12", ~D[2020-05-12], :valid},
    {nil, nil, :allow_nil},
    {"INVALID", "INVALID", :raise}
  ]

  describe ".cast_date/1" do
    for {given, expected, case_type} <- @cases, case_type in [:valid, :allow_nil] do
      test "with valid string #{inspect(given)} it returns expected" do
        assert Dates.cast_date(unquote(given)) ==
                 unquote(Macro.escape(expected))
      end

      test "with valid expected it returns expected #{inspect(given)}" do
        assert Dates.cast_date(unquote(Macro.escape(expected))) ==
                 unquote(Macro.escape(expected))
      end
    end

    for {given, _expected, :raise} <- @cases do
      test "with invalid #{inspect(given)} it raises" do
        assert_raise ArgumentError,
                     "cannot parse #{inspect(unquote(given))} as date, reason: :invalid_format",
                     fn ->
                       Dates.cast_date(unquote(given))
                     end
      end
    end
  end

  describe ".from_iso8601!/1" do
    for {given, expected, :valid} <- @cases do
      test "with valid date it returns #{inspect(given)}" do
        assert Dates.from_iso8601!(unquote(given)) ==
                 unquote(Macro.escape(expected))
      end
    end

    for {given, _expected, :allow_nil} <- @cases do
      test "with invalid #{inspect(given)} it raises" do
        assert_raise FunctionClauseError,
                     "no function clause matching in DarkMatter.Dates.from_iso8601!/1",
                     fn ->
                       Dates.from_iso8601!(unquote(given))
                     end
      end
    end

    for {given, _expected, :raise} <- @cases do
      test "with invalid #{inspect(given)} it raises" do
        assert_raise ArgumentError,
                     "cannot parse #{inspect(unquote(given))} as date, reason: :invalid_format",
                     fn ->
                       Dates.from_iso8601!(unquote(given))
                     end
      end
    end
  end

  describe ".to_string/1" do
    for {given, expected, case_type} <- @cases, case_type in [:valid, :allow_nil] do
      test "with valid expected it returns #{inspect(given)}" do
        assert Dates.to_string(unquote(Macro.escape(expected))) == unquote(given)
      end

      test "with valid string #{inspect(given)} it returns #{inspect(given)}" do
        assert Dates.to_string(unquote(given)) == unquote(given)
      end
    end

    for {given, _expected, :raise} <- @cases do
      test "with invalid #{inspect(given)} it raises" do
        assert_raise ArgumentError,
                     "cannot parse #{inspect(unquote(given))} as date, reason: :invalid_format",
                     fn ->
                       Dates.to_string(unquote(given))
                     end
      end
    end
  end
end
