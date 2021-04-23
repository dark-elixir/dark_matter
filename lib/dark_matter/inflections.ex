defmodule DarkMatter.Inflections do
  @moduledoc """
  General utils for working with case conversions.
  """
  @moduledoc since: "1.0.0"

  alias DarkMatter.Namings.AbsintheNaming
  alias DarkMatter.Namings.PhoenixNaming

  @typedoc """
  Available inflection conversions
  """
  @type conversion() ::
          :camel
          | :human
          | :title
          | :pascal
          | :plural
          | :singular
          | :constant
          | :underscore
          | :absinthe_camel
          | :absinthe_pascal

  @conversions [
    :camel,
    :human,
    :title,
    :pascal,
    :plural,
    :constant,
    :singular,
    :underscore,
    :absinthe_camel,
    :absinthe_pascal
  ]

  @doc """
  Converts either an atom or string to an atom based on the `conversion`.

  ## Examples

      iex> atom("_foo_bar123XYZ", :absinthe_camel)
      :_fooBar123XYZ

      iex> atom(:fooBarz___test, :camel)
      :fooBarzTest
  """
  @spec atom(atom() | String.t(), conversion() | [conversion(), ...]) :: atom()
  def atom(atom_or_binary, conversion_or_conversions)
      when (is_atom(atom_or_binary) or is_binary(atom_or_binary)) and
             (conversion_or_conversions in @conversions or is_list(conversion_or_conversions)) do
    atom_or_binary
    |> binary(conversion_or_conversions)
    |> String.to_atom()
  end

  @doc """
  Converts either an atom or string to a string based on the `conversion`.

  ## Examples

      iex> binary("_foo_bar123XYZ", :absinthe_pascal)
      "_FooBar123XYZ"

      iex> binary("_foo_bar123XYZ", :absinthe_camel)
      "_fooBar123XYZ"

      iex> binary(:fooBarz___TESTPDF, :pascal)
      "FooBarzTestpdf"

      iex> binary(:fooBarz___TESTPDF, :camel)
      "fooBarzTestpdf"

      iex> binary(:HTTP_PdfTEST, :underscore)
      "http_pdf_test"

      iex> binary("buses", :singular)
      "bus"

      iex> binary("business", :plural)
      "businesses"

      iex> binary("MerchantBusiness", [:plural, :underscore])
      "merchant_businesses"
  """
  @spec binary(atom() | String.t(), conversion() | [conversion(), ...]) :: String.t()
  def binary(binary, :camel) when is_binary(binary), do: camelize(binary)
  def binary(binary, :human) when is_binary(binary), do: humanize(binary)
  def binary(binary, :title) when is_binary(binary), do: titleize(binary)
  def binary(binary, :pascal) when is_binary(binary), do: pascalize(binary)
  def binary(binary, :plural) when is_binary(binary), do: pluralize(binary)
  def binary(binary, :constant) when is_binary(binary), do: constantize(binary)
  def binary(binary, :singular) when is_binary(binary), do: singularize(binary)
  def binary(binary, :underscore) when is_binary(binary), do: underscore(binary)
  def binary(binary, :absinthe_camel) when is_binary(binary), do: absinthe_camelize(binary)
  def binary(binary, :absinthe_pascal) when is_binary(binary), do: absinthe_pascalize(binary)

  def binary(atom_or_binary, conversion_or_conversions)
      when (is_atom(atom_or_binary) or is_binary(atom_or_binary)) and
             (conversion_or_conversions in @conversions or
                (is_list(conversion_or_conversions) and conversion_or_conversions != [])) do
    binary = if is_atom(atom_or_binary), do: Atom.to_string(atom_or_binary), else: atom_or_binary

    for conversion <- List.wrap(conversion_or_conversions),
        conversion in @conversions,
        reduce: binary do
      acc -> binary(acc, conversion)
    end
  end

  @doc """
  Returns the camel case version of the string

  ## Examples

      iex> absinthe_camelize("foo_bar")
      "fooBar"

      iex> absinthe_camelize("foo")
      "foo"

      iex> absinthe_camelize("__foo_bar")
      "__fooBar"

      iex> absinthe_camelize("__foo")
      "__foo"

      iex> absinthe_camelize("_foo")
      "_foo"
  """
  @spec absinthe_camelize(String.t()) :: String.t()
  def absinthe_camelize(binary) when is_binary(binary) do
    AbsintheNaming.camelize(binary, lower: true)
  end

  @doc """
  Returns the pascal case version of the string

  ## Examples

      iex> absinthe_pascalize("foo_bar")
      "FooBar"

      iex> absinthe_pascalize("foo")
      "Foo"

      iex> absinthe_pascalize("__foo_bar")
      "__FooBar"

      iex> absinthe_pascalize("__foo")
      "__Foo"

      iex> absinthe_pascalize("_foo")
      "_Foo"
  """
  @spec absinthe_pascalize(String.t()) :: String.t()
  def absinthe_pascalize(binary) when is_binary(binary) do
    AbsintheNaming.camelize(binary, lower: false)
  end

  @doc """
  Returns the upper case version of the string

  ## Examples

      iex> constantize("foo_bar")
      "FOO_BAR"

      iex> constantize("foo")
      "FOO"

      iex> constantize("__foo_bar")
      "FOO_BAR"

      iex> constantize("__foo")
      "FOO"

      iex> constantize("_foo")
      "FOO"
  """
  @spec constantize(String.t()) :: String.t()
  def constantize(binary) when is_binary(binary) do
    Recase.to_constant(binary)
  end

  @doc """
  Returns the pascal case version of the string

  ## Examples

      iex> camelize("foo_bar")
      "fooBar"

      iex> camelize("foo")
      "foo"

      iex> camelize("__foo_bar")
      "fooBar"

      iex> camelize("__foo")
      "foo"

      iex> camelize("_foo")
      "foo"
  """
  @spec camelize(String.t()) :: String.t()
  def camelize(binary) when is_binary(binary) do
    Recase.to_camel(binary)
  end

  @doc """
  Returns the humanized case version of the string

  ## Examples

      iex> humanize("foo_bar")
      "Foo bar"

      iex> humanize("foo")
      "Foo"

      iex> humanize("__foo_bar")
      "  foo bar"

      iex> humanize("__foo")
      "  foo"

      iex> humanize("_foo")
      " foo"
  """
  @spec humanize(String.t()) :: String.t()
  def humanize(binary) when is_binary(binary) do
    PhoenixNaming.humanize(binary)
  end

  @doc """
  Returns the titleize case version of the string

  ## Examples

      iex> titleize("foo_bar")
      "Foo Bar"

      iex> titleize("foo")
      "Foo"

      iex> titleize("__foo_bar")
      "Foo Bar"

      iex> titleize("__foo")
      "Foo"

      iex> titleize("_foo")
      "Foo"
  """
  @spec titleize(String.t()) :: String.t()
  def titleize(binary) when is_binary(binary) do
    Recase.to_title(binary)
  end

  @doc """
  Returns the camel case version of the string

  ## Examples

      iex> pascalize("foo_bar")
      "FooBar"

      iex> pascalize("foo")
      "Foo"

      iex> pascalize("__foo_bar")
      "FooBar"

      iex> pascalize("__foo")
      "Foo"

      iex> pascalize("_foo")
      "Foo"
  """
  @spec pascalize(String.t()) :: String.t()
  def pascalize(binary) when is_binary(binary) do
    Recase.to_pascal(binary)
  end

  @doc """
  Returns the singluar version of the string

  ## Examples

  With an uppercase first letter:

      iex> singularize("dogs")
      "dog"

      iex> singularize("people")
      "person"
  """
  @spec singularize(String.t()) :: String.t()
  def singularize(binary) when is_binary(binary) do
    Inflex.singularize(binary)
  end

  @doc """
  Returns the plural version of the string

  ## Examples

      iex> pluralize("dog")
      "dogs"

      iex> pluralize("person")
      "people"
  """
  @spec pluralize(String.t()) :: String.t()
  def pluralize(binary) when is_binary(binary) do
    Inflex.pluralize(binary)
  end

  @doc """
  Returns the underscore version of the string

  ## Examples

      iex> underscore("UpperCamelCase")
      "upper_camel_case"

      iex> underscore("pascalCase")
      "pascal_case"
  """
  @spec underscore(String.t()) :: String.t()
  def underscore(binary) when is_binary(binary) do
    Recase.to_snake(binary)
  end
end
