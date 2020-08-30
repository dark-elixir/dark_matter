defmodule DarkMatter.DateTimesTest do
  @moduledoc """
  Test for DarkMatter.DateTimes
  """

  use ExUnit.Case, async: true

  alias DarkMatter.DateTimes

  describe ".now!/0" do
    test "returns current datetime" do
      assert %DateTime{} = DateTimes.now!()
    end
  end

  @cases [
    {"2020-05-12T11:00:17.356201Z", ~U[2020-05-12T11:00:17.356201Z], :valid},
    {nil, nil, :allow_nil},
    {"INVALID", "INVALID", :raise}
  ]

  describe ".cast_datetime/1" do
    for {given, expected, case_type} <- @cases, case_type in [:valid, :allow_nil] do
      test "with valid string #{inspect(given)} it returns expected" do
        assert DateTimes.cast_datetime(unquote(given)) ==
                 unquote(Macro.escape(expected))
      end

      test "with valid expected it returns expected #{inspect(given)}" do
        assert DateTimes.cast_datetime(unquote(Macro.escape(expected))) ==
                 unquote(Macro.escape(expected))
      end
    end

    for {given, _expected, :raise} <- @cases do
      test "with invalid #{inspect(given)} it raises" do
        assert_raise ArgumentError,
                     "cannot parse #{inspect(unquote(given))} as datetime, reason: :invalid_format",
                     fn ->
                       DateTimes.cast_datetime(unquote(given))
                     end
      end
    end
  end

  describe ".from_iso8601!/1" do
    for {given, expected, :valid} <- @cases do
      test "with valid date it returns #{inspect(given)}" do
        assert DateTimes.from_iso8601!(unquote(given)) ==
                 unquote(Macro.escape(expected))
      end
    end

    for {given, _expected, :allow_nil} <- @cases do
      test "with invalid #{inspect(given)} it raises" do
        assert_raise FunctionClauseError,
                     "no function clause matching in DarkMatter.DateTimes.from_iso8601!/1",
                     fn ->
                       DateTimes.from_iso8601!(unquote(given))
                     end
      end
    end

    for {given, _expected, :raise} <- @cases do
      test "with invalid #{inspect(given)} it raises" do
        assert_raise ArgumentError,
                     "cannot parse #{inspect(unquote(given))} as datetime, reason: :invalid_format",
                     fn ->
                       DateTimes.from_iso8601!(unquote(given))
                     end
      end
    end
  end

  describe ".to_string/1" do
    for {given, expected, case_type} <- @cases, case_type in [:valid, :allow_nil] do
      test "with valid expected it returns #{inspect(given)}" do
        assert DateTimes.to_string(unquote(Macro.escape(expected))) == unquote(given)
      end

      test "with valid string #{inspect(given)} it returns #{inspect(given)}" do
        assert DateTimes.to_string(unquote(given)) == unquote(given)
      end
    end

    for {given, _expected, :raise} <- @cases do
      test "with invalid #{inspect(given)} it raises" do
        assert_raise ArgumentError,
                     "cannot parse #{inspect(unquote(given))} as datetime, reason: :invalid_format",
                     fn ->
                       DateTimes.to_string(unquote(given))
                     end
      end
    end
  end
end
