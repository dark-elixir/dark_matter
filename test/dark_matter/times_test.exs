defmodule DarkMatter.TimesTest do
  @moduledoc """
  Test for DarkMatter.Times
  """

  use ExUnit.Case, async: true

  alias DarkMatter.Times

  @cases [
    {"23:00:00", ~T[23:00:00], :valid},
    {"23:00:00.001", ~T[23:00:00.001], :valid},
    {nil, nil, :allow_nil},
    {"INVALID", "INVALID", :raise}
  ]

  describe ".cast_time/1" do
    for {given, expected, case_type} <- @cases, case_type in [:valid, :allow_nil] do
      test "with valid string #{inspect(given)} it returns expected" do
        assert Times.cast_time(unquote(given)) ==
                 unquote(Macro.escape(expected))
      end

      test "with valid expected it returns expected #{inspect(given)}" do
        assert Times.cast_time(unquote(Macro.escape(expected))) ==
                 unquote(Macro.escape(expected))
      end
    end

    for {given, _expected, :raise} <- @cases do
      test "with invalid #{inspect(given)} it raises" do
        assert_raise ArgumentError,
                     "cannot parse #{inspect(unquote(given))} as time, reason: :invalid_format",
                     fn ->
                       Times.cast_time(unquote(given))
                     end
      end
    end
  end

  describe ".from_iso8601!/1" do
    for {given, expected, :valid} <- @cases do
      test "with valid time it returns #{inspect(given)}" do
        assert Times.from_iso8601!(unquote(given)) ==
                 unquote(Macro.escape(expected))
      end
    end

    for {given, _expected, :allow_nil} <- @cases do
      test "with invalid #{inspect(given)} it raises" do
        assert_raise FunctionClauseError,
                     "no function clause matching in DarkMatter.Times.from_iso8601!/1",
                     fn ->
                       Times.from_iso8601!(unquote(given))
                     end
      end
    end

    for {given, _expected, :raise} <- @cases do
      test "with invalid #{inspect(given)} it raises" do
        assert_raise ArgumentError,
                     "cannot parse #{inspect(unquote(given))} as time, reason: :invalid_format",
                     fn ->
                       Times.from_iso8601!(unquote(given))
                     end
      end
    end
  end

  describe ".to_string/1" do
    for {given, expected, case_type} <- @cases, case_type in [:valid, :allow_nil] do
      test "with valid expected it returns #{inspect(given)}" do
        assert Times.to_string(unquote(Macro.escape(expected))) == unquote(given)
      end

      test "with valid string #{inspect(given)} it returns #{inspect(given)}" do
        assert Times.to_string(unquote(given)) == unquote(given)
      end
    end

    for {given, _expected, :raise} <- @cases do
      test "with invalid #{inspect(given)} it raises" do
        assert_raise ArgumentError,
                     "cannot parse #{inspect(unquote(given))} as time, reason: :invalid_format",
                     fn ->
                       Times.to_string(unquote(given))
                     end
      end
    end
  end
end
