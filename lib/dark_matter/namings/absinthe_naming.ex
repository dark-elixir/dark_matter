defmodule DarkMatter.Namings.AbsintheNaming do
  @moduledoc """
  Adapter for `Absinthe.Utils`.
  """

  case Code.ensure_compiled(Absinthe) do
    {:module, _module} ->
      @doc """
      Delegates to `Absinthe.Utils.camelize/1`.
      """
      @spec camelize(String.t()) :: String.t()
      defdelegate camelize(word), to: Absinthe.Utils

      @doc """
      Delegates to `Absinthe.Utils.camelize/2`.
      """
      @spec camelize(String.t(), Keyword.t()) :: String.t()
      defdelegate camelize(word, opts), to: Absinthe.Utils

    _any ->
      @doc """
      Camelize a word, respecting underscore prefixes.

      ## Examples

      With an uppercase first letter:

      ```
          iex> camelize("foo_bar")
          "FooBar"

          iex> camelize("foo")
          "Foo"

          iex> camelize("__foo_bar")
          "__FooBar"

          iex> camelize("__foo")
          "__Foo"

          iex> camelize("_foo")
          "_Foo"
      ```

      With a lowercase first letter:
      ```
          iex> camelize("foo_bar", lower: true)
          "fooBar"

          iex> camelize("foo", lower: true)
          "foo"

          iex> camelize("__foo_bar", lower: true)
          "__fooBar"

          iex> camelize("__foo", lower: true)
          "__foo"

          iex> camelize("_foo", lower: true)
          "_foo"
      ```
      """
      @spec camelize(binary, Keyword.t()) :: binary
      def camelize(word, opts \\ [])

      def camelize("_" <> word, opts) do
        "_" <> camelize(word, opts)
      end

      def camelize(word, opts) do
        case Enum.into(opts, %{}) do
          %{lower: true} ->
            {first, rest} = String.split_at(Macro.camelize(word), 1)
            String.downcase(first) <> rest

          _any ->
            Macro.camelize(word)
        end
      end
  end
end
