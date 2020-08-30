defmodule DarkMatter.Calendars do
  @moduledoc """
  Calendar utils.
  """
  @moduledoc since: "1.0.0"

  with {:module, _module} <- Code.ensure_compiled(Holidefs),
       {:module, _module} <- Code.ensure_compiled(Timex) do
    @typedoc """
    Holidefs `Holidefs.Holiday` struct
    """
    @type holiday() :: Holidefs.Holiday.t()

    @typedoc """
    Holidefs `Holidefs.Options` struct
    """
    @type holidef_opts() :: Holidefs.Options.attrs()

    @default_locale :us
    @default_holidef_opts [
      regions: [],
      include_informal?: false,
      observed?: false
    ]

    @doc """
    Determine if a `date` is a holiday
    """
    @spec holiday?(Date.t(), holidef_opts()) :: boolean()
    def holiday?(date, opts \\ @default_holidef_opts) do
      holidays_on!(date, opts) != []
    end

    @doc """
    Returns a list of holidays for a given `date` and `opts`.
    """
    @spec holidays_on(Date.t(), holidef_opts()) ::
            {:ok, [holiday()]} | {:error, Holidefs.error_reasons()}
    def holidays_on(date, opts \\ @default_holidef_opts) do
      Holidefs.on(@default_locale, date, opts)
    end

    @doc """
    Returns a list of holidays for a given `date` and `opts`.

    Raises `ArgumentError` otherwise.
    """
    @spec holidays_on!(Date.t(), holidef_opts()) :: [holiday()]
    def holidays_on!(date, opts \\ @default_holidef_opts) do
      case holidays_on(date, opts) do
        {:ok, holidays} when is_list(holidays) -> holidays
        {:error, reasons} -> raise ArgumentError, inspect(reasons)
      end
    end

    @doc """
    Determine if a `date` is a business day
    """
    @spec business_day?(Date.t()) :: boolean()
    def business_day?(date) do
      case Timex.weekday(date) do
        weekday when is_integer(weekday) -> weekday in 1..5
        {:error, reason} -> raise ArgumentError, inspect(reason)
      end
    end

    @doc """
    Determine if a `date` is a work business day
    """
    @spec working_business_day?(Date.t(), holidef_opts()) :: boolean()
    def working_business_day?(date, opts \\ @default_holidef_opts) do
      business_day?(date) and not holiday?(date, opts)
    end
  end
end
