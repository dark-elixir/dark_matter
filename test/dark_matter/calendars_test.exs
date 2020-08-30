defmodule DarkMatter.CalendarsTest do
  @moduledoc """
  Test for DarkMatter.Calendars
  """

  use ExUnit.Case, async: true

  alias DarkMatter.Calendars

  @business_days [~D[2020-03-09], ~D[2020-03-10], ~D[2020-03-11], ~D[2020-03-12], ~D[2020-03-13]]
  @weekend_days [~D[2020-03-14], ~D[2020-03-15]]
  @christmas ~D[2020-12-25]
  @new_years ~D[2020-01-01]
  @holidays [@christmas, @new_years]
  @non_holidays @business_days

  describe ".holiday?/1" do
    for holiday <- @holidays do
      test "with valid :holiday #{holiday}" do
        assert Calendars.holiday?(unquote(Macro.escape(holiday))) == true
      end
    end

    for non_holiday <- @non_holidays do
      test "with valid :non_holiday #{non_holiday}" do
        assert Calendars.holiday?(unquote(Macro.escape(non_holiday))) == false
      end
    end
  end

  describe ".holidays_on/1" do
    test "with valid :christmas" do
      assert Calendars.holidays_on(@christmas) ==
               {:ok,
                [
                  %Holidefs.Holiday{
                    date: ~D[2020-12-25],
                    informal?: false,
                    name: "Christmas Day",
                    observed_date: ~D[2020-12-25],
                    raw_date: ~D[2020-12-25]
                  }
                ]}
    end

    test "with valid :new_years" do
      assert Calendars.holidays_on(@new_years) ==
               {:ok,
                [
                  %Holidefs.Holiday{
                    date: ~D[2020-01-01],
                    informal?: false,
                    name: "New Year's Day",
                    observed_date: ~D[2020-01-01],
                    raw_date: ~D[2020-01-01]
                  }
                ]}
    end

    for non_holiday <- @non_holidays do
      test "with valid :non_holiday #{non_holiday}" do
        assert Calendars.holidays_on(unquote(Macro.escape(non_holiday))) == {:ok, []}
      end
    end
  end

  describe ".holidays_on!/1" do
    test "with valid :christmas" do
      assert Calendars.holidays_on!(@christmas) ==
               [
                 %Holidefs.Holiday{
                   date: ~D[2020-12-25],
                   informal?: false,
                   name: "Christmas Day",
                   observed_date: ~D[2020-12-25],
                   raw_date: ~D[2020-12-25]
                 }
               ]
    end

    test "with valid :new_years" do
      assert Calendars.holidays_on!(@new_years) ==
               [
                 %Holidefs.Holiday{
                   date: ~D[2020-01-01],
                   informal?: false,
                   name: "New Year's Day",
                   observed_date: ~D[2020-01-01],
                   raw_date: ~D[2020-01-01]
                 }
               ]
    end

    for non_holiday <- @non_holidays do
      test "with valid :non_holiday #{non_holiday}" do
        assert Calendars.holidays_on!(unquote(Macro.escape(non_holiday))) == []
      end
    end

    test "with invalid date (nil) it raises" do
      date = nil

      assert_raise ArgumentError, fn ->
        Calendars.holidays_on!(date)
      end
    end
  end

  describe ".business_day?/1" do
    for business_day <- @business_days do
      test "with valid :business_day #{business_day}" do
        assert Calendars.business_day?(unquote(Macro.escape(business_day))) == true
      end
    end

    for weekend_day <- @weekend_days do
      test "with invalid :weekend_day #{inspect(weekend_day)}" do
        assert Calendars.business_day?(unquote(Macro.escape(weekend_day))) == false
      end
    end

    test "with invalid date (nil) it raises" do
      date = nil

      assert_raise ArgumentError, fn ->
        Calendars.business_day?(date)
      end
    end
  end

  describe ".working_business_day?/1" do
    test "given :christmas" do
      assert Calendars.working_business_day?(@christmas) == false
    end

    for business_day <- @business_days do
      test "with valid :business_day #{business_day}" do
        assert Calendars.working_business_day?(unquote(Macro.escape(business_day))) == true
      end
    end

    for weekend_day <- @weekend_days do
      test "with invalid :weekend_day #{inspect(weekend_day)}" do
        assert Calendars.working_business_day?(unquote(Macro.escape(weekend_day))) == false
      end
    end
  end
end
