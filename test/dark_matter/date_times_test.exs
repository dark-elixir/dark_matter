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
    {~U[2020-05-12T11:00:17.356201Z], ~U[2020-05-12T11:00:17.356201Z], :idempotent},
    {"2020-05-12T11:00:17.356201Z", ~U[2020-05-12T11:00:17.356201Z], :valid},
    {nil, nil, :allow_nil},
    {"INVALID", "INVALID", :raise}
  ]

  # @unix_cases [
  #   {nil, nil, :allow_nil},
  #   {~U[1970-01-01 00:16:40.000000Z], 1_000_000_000_000, :valid},
  #   {~U[1989-09-10 15:04:13.281635Z], 621_443_053_281_635_000, :valid}
  # ]

  # @cf_absolute_time_cases [
  #   {nil, nil, :allow_nil},
  #   # {~U[1970-01-01 00:16:40.000000Z], 1_000_000_000_000, :valid},
  #   {~U[2020-09-10 15:04:13.281635Z], 621_443_053_281_635_000, :valid}
  # ]

  describe ".cast_datetime/1" do
    for {given, expected, case_type} <- @cases,
        case_type in [:valid, :unix, :allow_nil, :idempotent] do
      test "with valid string #{inspect(given)} it returns expected" do
        assert DateTimes.cast_datetime(unquote(Macro.escape(given))) ==
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
                     "cannot parse #{inspect(unquote(Macro.escape(given)))} as datetime, reason: :invalid_format",
                     fn ->
                       DateTimes.cast_datetime(unquote(Macro.escape(given)))
                     end
      end
    end
  end

  # describe ".cast_unix/1" do
  #   test "offset example" do
  #     offset = DateTime.to_unix(~U[2001-01-01 00:00:00.000000Z], :nanosecond)
  #     unix = 621_443_053_281_635_000
  #     given = unix + offset
  #     assert DateTime.from_unix!(given, :nanosecond) == ~U[2020-09-10 15:04:13.281635Z]
  #   end

  #   for {given, expected, case_type} <- @unix_cases, case_type in [:valid, :allow_nil] do
  #     test "with valid string #{inspect(given)} it returns expected" do
  #       assert DateTimes.cast_unix(unquote(Macro.escape(given))) ==
  #                unquote(Macro.escape(expected))
  #     end

  #     test "with valid expected it returns expected #{inspect(given)}" do
  #       assert DateTimes.cast_unix(unquote(Macro.escape(expected))) ==
  #                unquote(Macro.escape(expected))
  #     end
  #   end

  #   for {given, _expected, :raise} <- @unix_cases do
  #     test "with invalid #{inspect(given)} it raises" do
  #       assert_raise ArgumentError,
  #                    "cannot parse #{inspect(unquote(given))} as datetime, reason: :invalid_format",
  #                    fn ->
  #                      DateTimes.cast_unix(unquote(given))
  #                    end
  #     end
  #   end
  # end

  describe ".from_iso8601!/1" do
    for {given, expected, :valid} <- @cases do
      test "with valid date it returns #{inspect(given)}" do
        assert DateTimes.from_iso8601!(unquote(Macro.escape(given))) ==
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

    for {given, _expected, case_type} <- @cases, case_type in [:raise] do
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
        assert DateTimes.to_string(unquote(Macro.escape(expected))) ==
                 unquote(Macro.escape(given))
      end

      test "with valid string #{inspect(given)} it returns #{inspect(given)}" do
        assert DateTimes.to_string(unquote(Macro.escape(expected))) ==
                 unquote(Macro.escape(given))
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
