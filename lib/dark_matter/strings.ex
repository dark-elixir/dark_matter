defmodule DarkMatter.Strings do
  @moduledoc """
  General utils for working with strings.
  """
  @moduledoc since: "1.0.0"

  @regex %{
    non_word: ~r/\W/u,
    non_digit: ~r/\D/,
    whitespace: ~r/[\n\s]+/,
    diacritics: Regex.compile!("[\u0300-\u036f]")
  }

  @doc """
  Determine if a string is blank.

  ## Examples

      iex> blank?(nil)
      true

      iex> blank?("")
      true

      iex> blank?("   ")
      false

      iex> blank?("a dog ran down the street")
      false
  """
  @spec blank?(nil | String.t()) :: boolean()
  def blank?(nil) do
    true
  end

  def blank?("") do
    true
  end

  def blank?(binary) when is_binary(binary) do
    false
  end

  @doc """
  Determine if a string is blank.

  ## Examples

      iex> blank?("   ", trim: true)
      true

      iex> blank?("   ", %{trim: true})
      true
  """
  @spec blank?(nil | String.t(), list() | %{optional(:trim) => boolean()}) :: boolean()
  def blank?(nil, _opts) do
    true
  end

  def blank?(binary, opts) when is_list(opts) do
    blank?(binary, Enum.into(opts, %{}))
  end

  def blank?(binary, %{trim: true}) when is_binary(binary) do
    binary |> String.trim() |> blank?()
  end

  def blank?(binary, _opts) when is_binary(binary) do
    false
  end

  @doc """
  Normalize a binary.

  ## Examples

      iex> normalize("a dog ran down the street")
      "a dog ran down the street"
  """
  @spec normalize(String.t()) :: String.t()
  def normalize(binary) when is_binary(binary) do
    binary
    |> :unicode.characters_to_nfd_binary()
    |> String.replace(@regex.diacritics, "")
  end

  @doc """
  Strip non-alphanumeric chars from binary

  ## Examples

      iex> strip_non_digit("a dog ran down the street")
      ""

      iex> strip_non_digit("123-456#1526")
      "1234561526"
  """
  @spec strip_non_digit(String.t()) :: String.t()
  def strip_non_digit(binary) when is_binary(binary) do
    String.replace(binary, @regex.non_digit, "")
  end

  @doc """
  Removes non word characters.

  ## Examples

      iex> strip_non_words_characters("a dog ran down the street")
      "adograndownthestreet"
  """
  @spec strip_non_words_characters(String.t()) :: String.t()
  def strip_non_words_characters(binary) when is_binary(binary) do
    String.replace(binary, @regex.non_word, "")
  end

  @doc """
  Removes whitespace chars.

  ## Examples

      iex> strip_whitespace("a dog ran down the street")
      "adograndownthestreet"
  """
  @spec strip_whitespace(String.t(), String.t()) :: String.t()
  def strip_whitespace(binary, replacement \\ "")
      when is_binary(binary) and is_binary(replacement) do
    String.replace(binary, @regex.whitespace, replacement)
  end

  @doc """
  Concats a list of strings.  Similar to `CONCAT_WS` in postgres.

  ## Examples

      iex> concat_ws(["", nil, %{}, "first", "time"])
      "first time"
  """
  @spec concat_ws(list(String.t() | nil), String.t()) :: String.t()
  def concat_ws(list, joiner \\ " ") when is_list(list) and is_binary(joiner) do
    list
    |> Enum.reject(&is_nil/1)
    |> Enum.filter(&is_binary/1)
    |> Enum.reject(&blank?(&1, trim: true))
    |> Enum.join(joiner)
  end

  @doc """
  Capitalizes all words in the given `binary` that are separated by the given `separator`

  ## Examples

      iex> capitalize_words("a dog ran down the street")
      "A Dog Ran Down The Street"
  """
  @spec capitalize_words(String.t(), String.t()) :: String.t()
  def capitalize_words(binary, separator \\ " ") when is_binary(binary) do
    binary
    |> String.split(separator)
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(separator)
  end
end
